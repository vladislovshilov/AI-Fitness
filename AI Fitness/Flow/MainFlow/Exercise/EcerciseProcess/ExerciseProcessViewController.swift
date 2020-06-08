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
    @IBOutlet private var capturedJointConfidenceLabels: [UILabel]!
    @IBOutlet private var capturedJointBGViews: [UIView]!
    
    var onFinishHandler: (() -> Void)?
    var onCancelHandler: (() -> Void)?
    
    private var capturedPointsArray: [[CapturedPoint?]?] = []
    
    private var capturedIndex = 0
    
    private var currentPoseIndex = 2
    
    private var player: AVAudioPlayer?
    
    private var isCompleted = true
    
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
    
    init(screenOrientationService: IScreenOrientationService) {
        self.screenOrientationService = screenOrientationService
        super.init(nibName: nil, bundle: nil)
        
//        screenOrientationService.changeLockedInterfaceOrientation(.landscapeRight)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the drawing views
        setUpCapturedJointView()
        
        // setup the model
        setUpModel()
        
        // setup camera
        setUpCamera()
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
    
    private func playFolowNextPoseSound() {
        guard let url = Bundle.main.url(forResource: "follow next pose", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - IBActions's
    
    @IBAction func captureButtonDidPress(_ sender: Any) {
        capturedIndex = 3
        let head = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.23020833333333334),
                                  maxConfidence: 2.16162109375)
        let neck = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.42465277777777785),
                                  maxConfidence: 1.099365234375)
        let r1 = PredictedPoint(maxPoint: .init(x: 0.68645833333333337, y: 0.43854166666666669),
                                maxConfidence: 0.5916748046875)
        let r2 = PredictedPoint(maxPoint: .init(x: 0.68645833333333337, y: 0.60520833333333337),
                                maxConfidence: 0.44671630859375)
        let r3 = PredictedPoint(maxPoint: .init(x: 0.68923611111111116, y: 0.66076388888888895),
                                maxConfidence: 0.0670013427734375)
        let l1 = PredictedPoint(maxPoint: .init(x: 0.40868055555555547, y: 0.48020833333333331),
                                maxConfidence: 1.68994140625)
        let l2 = PredictedPoint(maxPoint: .init(x: 0.38090277777777773, y: 0.68854166666666663),
                                maxConfidence: 0.6737060546875)
        let l3 = PredictedPoint(maxPoint: .init(x: 0.41701388888888884, y: 0.69409722222222215),
                                maxConfidence: 0.187255859375)
        let predictedPoints = [head, neck, r1, r2, r3, l1, l2, l3, nil, nil, nil, nil, nil ,nil]

        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }

        let encodedData = NSKeyedArchiver.archivedData(withRootObject: capturedPoints)
        UserDefaults.standard.set(encodedData, forKey: "points-\(capturedIndex)")
        print(UserDefaults.standard.synchronize())
        
        
        
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
    }
    
    @IBAction func finishButtonDidPress(_ sender: Any) {
        onFinishHandler?()
    }
    
    @IBAction func cancelButtonDidPress(_ sender: Any) {
        onCancelHandler?()
    }
}

// MARK: - Helper methods

extension ExerciseProcessViewController {
    
    // MARK: - Setup Captured Joint View
    func setUpCapturedJointView() {
        postProcessor.onlyBust = true
        
        for capturedJointView in capturedJointViews {
            capturedJointView.layer.borderWidth = 2
            capturedJointView.layer.borderColor = UIColor.gray.cgColor
        }
        
        capturedPointsArray = capturedJointViews.map { _ in return nil }
        
        if let data = UserDefaults.standard.data(forKey: "points-\(currentPoseIndex)"),
            let capturedPoints = NSKeyedUnarchiver.unarchiveObject(with: data) as? [CapturedPoint?] {
            
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
            guard let self = self else { return }
            // draw line
            self.jointView.bodyPoints = predictedPoints
            
            var topCapturedJointBGView: UIView?
            var maxMatchingRatio: CGFloat = 0
            
            let text = String(format: "%.2f%", matchingRatios[0]*100)
            self.capturedJointConfidenceLabels[0].text = text
            self.capturedJointBGViews[0].backgroundColor = .clear
            if matchingRatios[0] > 0.80 && maxMatchingRatio < matchingRatios[0] {
                guard self.isCompleted else { return }
                self.isCompleted = false
                print("Date - \(Date())")
                print("become false")
                
                maxMatchingRatio = matchingRatios[0]
                topCapturedJointBGView = self.capturedJointBGViews[0]
                
                self.currentPoseIndex = self.currentPoseIndex == 2 ? 3 : 2
                self.playFolowNextPoseSound()
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    self.setUpCapturedJointView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isCompleted = true
                        print("Date - \(Date())")
                        print("become true")
                    }
                })
            }
            
            topCapturedJointBGView?.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.4)
            //            print(matchingRatios)
        }
        /* =================================================================== */
    }
}
