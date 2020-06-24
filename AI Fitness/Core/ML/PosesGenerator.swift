//
//  ModelsGenerator.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/8/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

final class PosesGenerator {
    static func generatePoses() {
        generatePlankPose()
        generateSumoPose()
    }
    
    static func generateWeightPose() -> WeightPose {
        let pose1 = generateWeight1Pose()
        let pose2 = generateWeight2Pose()
        return WeightPose(poses: [pose1, pose2])
    }
    
    private static func generateWeight1Pose() -> Pose {
        let head = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.23020833333333334),
                                  maxConfidence: 0.6737060546875)
        let neck = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.42465277777777785),
                                  maxConfidence: 0.6737060546875)
        let r1 = PredictedPoint(maxPoint: .init(x: 0.68645833333333337,
                                                y: 0.43854166666666669),
                                maxConfidence: 0.6737060546875)
        let r2 = PredictedPoint(maxPoint: .init(x: 0.74645833333333337,
                                                y: 0.58854166666666663),
                                maxConfidence: 0.6737060546875)
        let r3 = PredictedPoint(maxPoint: .init(x: 0.68645833333333337,
                                                y: 0.69409722222222215),
                                maxConfidence: 0.6737060546875)
        let l1 = PredictedPoint(maxPoint: .init(x: 0.40868055555555547,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let l2 = PredictedPoint(maxPoint: .init(x: 0.32090277777777773,
                                                y: 0.58854166666666663),
                                maxConfidence: 0.6737060546875)
        let l3 = PredictedPoint(maxPoint: .init(x: 0.40868055555555547,
                                                y: 0.69409722222222215),
                                maxConfidence: 0.6737060546875)
        let predictedPoints = [head, neck, r1, r2, r3, l1, l2, l3, nil, nil, nil, nil, nil ,nil]

        savePose(pose: predictedPoints, forIndex: 2)
        
        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }
        
        return Pose(points: capturedPoints,
                    poseChangeTime: 5)
    }
    
    private static func generateWeight2Pose() -> Pose {
        let head = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.23020833333333334),
                                  maxConfidence: 0.6737060546875)
        let neck = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.42465277777777785),
                                  maxConfidence: 0.6737060546875)
        let r1 = PredictedPoint(maxPoint: .init(x: 0.68645833333333337,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let r2 = PredictedPoint(maxPoint: .init(x: 0.74,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let r3 = PredictedPoint(maxPoint: .init(x: 0.86,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let l1 = PredictedPoint(maxPoint: .init(x: 0.40868055555555547,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let l2 = PredictedPoint(maxPoint: .init(x: 0.36,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let l3 = PredictedPoint(maxPoint: .init(x: 0.24,
                                                y: 0.48020833333333331),
                                maxConfidence: 0.6737060546875)
        let predictedPoints = [head, neck, r1, r2, r3, l1, l2, l3, nil, nil, nil, nil, nil ,nil]
        
        savePose(pose: predictedPoints, forIndex: 3)
        
        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }
        
        return Pose(points: capturedPoints,
                    poseChangeTime: 5)
    }
    
    private static func generatePlankPose() {
        let head = PredictedPoint(maxPoint: .init(x: 0.1,
                                                  y: 0.4),
                                  maxConfidence: 2.16162109375)
        let neck = PredictedPoint(maxPoint: .init(x: 0.2, y: 0.42465277777777785),
                                  maxConfidence: 1.099365234375)
        let r1 = PredictedPoint(maxPoint: .init(x: 0.2, y: 0.46854166666666669),
                                maxConfidence: 0.5916748046875)
        let r2 = PredictedPoint(maxPoint: .init(x: 0.2, y: 0.60520833333333337),
                                maxConfidence: 0.44671630859375)
        let r3 = PredictedPoint(maxPoint: .init(x: 0.13, y: 0.60520833333333337),
                                maxConfidence: 0.0670013427734375)
        let l1 = PredictedPoint(maxPoint: .init(x: 0.18, y: 0.48020833333333331),
                                maxConfidence: 1.68994140625)
        let l2 = PredictedPoint(maxPoint: .init(x: 0.18, y: 0.606),
                                maxConfidence: 0.6737060546875)
        let l3 = PredictedPoint(maxPoint: .init(x: 0.13, y: 0.606),
                                maxConfidence: 0.187255859375)
        let rl1 = PredictedPoint(maxPoint: .init(x: 0.4, y: 0.45),
                                   maxConfidence: 0.187255859375)
        let rl2 = PredictedPoint(maxPoint: .init(x: 0.642323, y: 0.55323),
        maxConfidence: 0.187255859375)
        let rl3 = PredictedPoint(maxPoint: .init(x: 0.7, y: 0.59),
                                 maxConfidence: 0.187255859375)
        let ll1 = PredictedPoint(maxPoint: .init(x: 0.4, y: 0.45),
        maxConfidence: 0.187255859375)
        let ll2 = PredictedPoint(maxPoint: .init(x: 0.662323, y: 0.57323),
        maxConfidence: 0.187255859375)
        let ll3 = PredictedPoint(maxPoint: .init(x: 0.71, y: 0.5912),
        maxConfidence: 0.187255859375)
        let predictedPoints = [head, neck, r1, r2, r3, l1, l2, l3, rl1, rl2, rl3, ll1, ll2 ,ll3]
        
        savePose(pose: predictedPoints, forIndex: 0)
    }
    
    private static func generateSumoPose() {
        let head = PredictedPoint(maxPoint: .init(x: 0.53368055555555558,
                                                  y: 0.23020833333333334),
                                  maxConfidence: 2.16162109375)
        let neck = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.32465277777777785),
                                  maxConfidence: 1.099365234375)
        let r1 = PredictedPoint(maxPoint: .init(x: 0.48, y: 0.35),
                                maxConfidence: 0.5916748046875)
        let r2 = PredictedPoint(maxPoint: .init(x: 0.48, y: 0.56),
                                maxConfidence: 0.44671630859375)
        let r3 = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.45),
                                maxConfidence: 0.0670013427734375)
        let l1 = PredictedPoint(maxPoint: .init(x: 0.58, y: 0.35),
                                maxConfidence: 1.68994140625)
        let l2 = PredictedPoint(maxPoint: .init(x: 0.58, y: 0.56),
                                maxConfidence: 0.6737060546875)
        let l3 = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.45),
                                maxConfidence: 0.187255859375)
        let rl1 = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.67),
                                 maxConfidence: 0.187255859375)
        let rl2 = PredictedPoint(maxPoint: .init(x: 0.342323, y: 0.67),
                                 maxConfidence: 0.187255859375)
        let rl3 = PredictedPoint(maxPoint: .init(x: 0.342323, y: 0.8912),
                                 maxConfidence: 0.187255859375)
        let ll1 = PredictedPoint(maxPoint: .init(x: 0.53368055555555558, y: 0.67),
                                 maxConfidence: 0.187255859375)
        let ll2 = PredictedPoint(maxPoint: .init(x: 0.712323, y: 0.67),
                                 maxConfidence: 0.187255859375)
        let ll3 = PredictedPoint(maxPoint: .init(x: 0.712323, y: 0.8912),
                                 maxConfidence: 0.187255859375)
        let predictedPoints = [head, neck, r1, r2, r3, l1, l2, l3, rl1, rl2, rl3, ll1, ll2 ,ll3]
        
        savePose(pose: predictedPoints, forIndex: 1)
    }
    
    private static func savePose(pose: [PredictedPoint?], forIndex index: Int) {
        let capturedPoints: [CapturedPoint?] = pose.map { predictedPoint in
            guard let predictedPoint = predictedPoint else { return nil }
            return CapturedPoint(predictedPoint: predictedPoint)
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: capturedPoints)
        UserDefaults.standard.set(encodedData, forKey: "points-\(index)")
        print(UserDefaults.standard.synchronize())
    }
}
