//
//  ExerciseProcessViewController.swift
//  AI Fitness
//
//  Created by Vlados iOS on 5/20/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import UIKit
import CoreMedia
import Vision
import AVFoundation

protocol ExerciseProcessOutput {
    var onFinishHandler: (() -> Void)? { get set }
    var onCancelHandler: (() -> Void)? { get set }
}

class ExerciseProcessViewController: BaseController, ExerciseProcessOutput {
    // MARK: - IBOutlets
    @IBOutlet private weak var videoPreview: UIView!
    @IBOutlet private weak var jointView: DrawingJointView!
    @IBOutlet private var capturedJointViews: [DrawingJointView]!
    @IBOutlet private var capturedJointConfidenceLabels: UILabel!
    @IBOutlet private var capturedJointBGViews: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    
    var onFinishHandler: (() -> Void)?
    var onCancelHandler: (() -> Void)?
    
    private var capturedPointsArray: [[CapturedPoint?]?] = []
    
    private var capturedIndex = 0
    
    private var player: AVAudioPlayer?
    
    private var isCompleted = true
    private var isFullyCompleted = false
    private var shouldPlayMoveSlower = true
    
    // MARK: - AV Property
    private var videoCapture: VideoCapture!
    
    // MARK: - ML Properties
    // Core ML model
    typealias EstimationModel = model_cpm
    
    // Preprocess and Inference
    private var request: VNCoreMLRequest?
    private var visionModel: VNCoreMLModel?
    
    // Postprocess
    private var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
    private var mvfilters: [MovingAverageFilter] = []
    
    private var screenOrientationService: IScreenOrientationService
    
    private var pose: ExercisePose
    
    private var timer: Timer?
    private var poseTimerStartTime: TimeInterval = 0
    private var moveFasterTiming: TimeInterval = 5
    private var timerValue: TimeInterval = 5 {
        didSet {
            timerLabel.text = "\(timerValue.rounded())"
            timerLabel.textColor = timerValue < 0 ? .red : .white
        }
    }
    
    private var poseAchieveTime: TimeInterval = 0
    
    init(screenOrientationService: IScreenOrientationService,
         pose: ExercisePose) {
        self.screenOrientationService = screenOrientationService
        self.pose = pose
        super.init(nibName: nil, bundle: nil)
        
//        screenOrientationService.changeLockedInterfaceOrientation(.landscapeRight)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerValue = pose.currentPose.poseChangeTime
        
        setUpCapturedJointView()
        setUpModel()
        setUpCamera()
        
        poseTimerStartTime = Date().timeIntervalSince1970
        poseAchieveTime = poseTimerStartTime
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeRight
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoCapture.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoCapture.stop()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        screenOrientationService.changeLockedInterfaceOrientation(.portrait)
    }
    
    // MARK: - Support methods
    
    enum Sound {
        case followNextPose, moveFaster, moveSlower, exerciseCompleted
        
        var resourceName: String {
            switch self {
            case .followNextPose:
                return "follow next pose"
            case .moveFaster:
                return "move faster"
            case .moveSlower:
                return "move slower"
            case .exerciseCompleted:
                return "exercise completed"
            }
        }
    }
    
    private func playSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.resourceName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - IBActions's
    
//    @IBAction func captureButtonDidPress(_ sender: Any) {
//        let currentIndex = capturedIndex % capturedJointViews.count
//        let capturedJointView = capturedJointViews[currentIndex]
//
//        let predictedPoints = jointView.bodyPoints
//        capturedJointView.bodyPoints = predictedPoints
//        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
//            guard let predictedPoint = predictedPoint else { return nil }
//            return CapturedPoint(predictedPoint: predictedPoint)
//        }
//        capturedPointsArray[currentIndex] = capturedPoints
//
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: capturedPoints)
//        UserDefaults.standard.set(encodedData, forKey: "points-\(currentIndex)")
//        print(UserDefaults.standard.synchronize())
//
//        capturedIndex += 1
//    }
    
    @IBAction private func finishButtonDidPress(_ sender: Any) {
        stopExercise()
        onFinishHandler?()
    }
    
    @IBAction private func cancelButtonDidPress(_ sender: Any) {
        stopExercise()
        onCancelHandler?()
    }
}

// MARK: - Helper methods

extension ExerciseProcessViewController {
    private func stopExercise() {
        timer?.invalidate()
        isFullyCompleted = true
        videoCapture.stop()
        playSound(.exerciseCompleted)
    }
    
    private func completeExercise() {
        stopExercise()
        
        let vc = ExerciseResultViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.accuracyValue = pose.averageAccuracy
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - Setup Captured Joint View
    func setUpCapturedJointView() {
        postProcessor.onlyBust = true
        
        for capturedJointView in capturedJointViews {
            capturedJointView.layer.borderWidth = 2
            capturedJointView.layer.borderColor = UIColor.gray.cgColor
        }
        
        capturedPointsArray = capturedJointViews.map { _ in return nil }
        
        let poses = pose.currentPose
        let capturedPoints = poses.points
        
        if self.pose.remaningSets <= 0 {
            self.isCompleted = true
            self.completeExercise()
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.capturedPointsArray[0] = capturedPoints
            self.capturedJointViews[0].bodyPoints = capturedPoints.map { capturedPoint in
                if let capturedPoint = capturedPoint { return PredictedPoint(capturedPoint: capturedPoint) }
                else { return nil }
            }
        }, completion: { _ in
            //                self.isCompleted = true
        })
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model) {
            self.visionModel = visionModel
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request?.imageCropAndScaleOption = .centerCrop
        } else {
            fatalError("cannot load the ml model")
        }
    }
    
    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480, cameraPosition: .front) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    DispatchQueue.main.async {
                        self.videoPreview.layer.addSublayer(previewLayer)
                        self.resizePreviewLayer()
                    }
                }
                
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

// MARK: - VideoCaptureDelegate
extension ExerciseProcessViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        predictUsingVision(pixelBuffer: pixelBuffer)
    }
}

extension ExerciseProcessViewController {
    // MARK: - Inferencing
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        guard let request = request else { fatalError() }
        // vision framework configures the input size of image following our model's input configuration automatically
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    // MARK: - Postprocessing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        guard !isFullyCompleted else { return }
        guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmaps = observations.first?.featureValue.multiArrayValue else { return }
        
        /* =================================================================== */
        /* ========================= post-processing ========================= */
        
        /* ------------------ convert heatmap to point array ----------------- */
        var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps, isFlipped: true)
        
        /* --------------------- moving average filter ----------------------- */
        if predictedPoints.count != mvfilters.count {
            mvfilters = predictedPoints.map { _ in MovingAverageFilter(limit: 3) }
        }
        for (predictedPoint, filter) in zip(predictedPoints, mvfilters) {
            filter.add(element: predictedPoint)
        }
        predictedPoints = mvfilters.map { $0.averagedValue() }
        /* =================================================================== */
        
        let matchingRatios = capturedPointsArray
            .map { $0?.matchVector(with: predictedPoints) }
            .compactMap { $0 }
        
        
        
        /* =================================================================== */
        /* ======================= display the results ======================= */
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let matchingRatio = matchingRatios.first else { return }
            // draw line
            self.jointView.bodyPoints = predictedPoints
            
            var topCapturedJointBGView: UIView?
            
            let text = String(format: "%.2f%", matchingRatio*100)
            self.capturedJointConfidenceLabels.text = text
            self.capturedJointBGViews.backgroundColor = .clear
            if matchingRatio > 0.80 {
                guard self.isCompleted else { return }
                self.isCompleted = false
                self.poseAchieveTime = Date().timeIntervalSince1970
                
                self.moveFasterTiming = 5
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
                    self.timerValue = self.poseTimerStartTime + self.pose.currentPose.poseChangeTime - Date().timeIntervalSince1970
                    if self.poseTimerStartTime + self.pose.currentPose.poseChangeTime + self.moveFasterTiming < Date().timeIntervalSince1970 {
                        self.moveFasterTiming += 5
                        self.playSound(.moveFaster)
                    }
                })
                RunLoop.current.add(self.timer!, forMode: .common)
                self.timer?.tolerance = 0.2
                
                if self.poseTimerStartTime + self.pose.currentPose.poseChangeTime > Date().timeIntervalSince1970  {
                    self.shouldPlayMoveSlower = false
                    self.playSound(.moveSlower)
                    self.confirmNextPose()
                   
                    return
                }

                topCapturedJointBGView = self.capturedJointBGViews
                
                self.confirmNextPose()
                self.playSound(.followNextPose)
            }
            
            topCapturedJointBGView?.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.4)
            //            print(matchingRatios)
        }
        /* =================================================================== */
    }
    
    private func confirmNextPose() {
        let achieveTimeDelta = poseTimerStartTime + pose.currentPose.poseChangeTime - poseAchieveTime
        let time = abs(achieveTimeDelta.rounded())
        print("Achive delta \(time)")
        pose.confirmPose(time: time)
        let _ = pose.nextPose()
        
        poseTimerStartTime = Date().timeIntervalSince1970
        
        setUpCapturedJointView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isCompleted = true
            self.shouldPlayMoveSlower = true
        }
    }
}
