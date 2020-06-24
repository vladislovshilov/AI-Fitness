//
//  Pose.swift
//  AI Fitness
//
//  Created by Vlados iOS on 6/21/20.
//  Copyright © 2020 Vladislav Shilov. All rights reserved.
//

import Foundation

struct Pose {
    var points: [CapturedPoint?]
    var poseChangeTime: TimeInterval
}

protocol ExercisePose {
    var currentPoseIndex: Int { get set }
    var poses: [Pose] { get set }
    var currentPose: Pose { get }
    var numberOfSets: Int { get set }
    var remaningSets: Int { get set }
    
    var accuracies: [Double] { get set }
    var averageAccuracy: Double { get }
    
    mutating func confirmPose(time: TimeInterval)
    mutating func nextPose() -> Pose
}

extension ExercisePose {
    var currentPose: Pose {
        return poses[currentPoseIndex]
    }
    
    mutating func confirmPose(time: TimeInterval) {
        guard currentPoseIndex < numberOfSets * 2 else { return }
        let poseChangeTime = poses[(currentPoseIndex) % poses.count].poseChangeTime
        let realTime = time <= poseChangeTime ? time : poseChangeTime / time
        let accuracy = 100 * realTime / poseChangeTime
 
        print("accuracy \(accuracy)")
        
        accuracies[currentPoseIndex] = accuracy
    }
    
    mutating func nextPose() -> Pose {
        currentPoseIndex += 1
        remaningSets = remaningSets - (currentPoseIndex) % poses.count
        return poses[(currentPoseIndex - 1) % poses.count]
    }
}

struct WeightPose: ExercisePose {
    var remaningSets = 4
    var numberOfSets = 4
    var currentPoseIndex = 0
    var poses: [Pose]
    var currentPose: Pose {
        return poses[(currentPoseIndex) % poses.count]
    }
    
    var accuracies: [Double]
    var averageAccuracy: Double {
        let sum = accuracies.reduce(0, +)
        return sum / Double(accuracies.count)
    }
    
    init(poses: [Pose]) {
        self.poses = poses
        accuracies = .init(repeating: 0, count: numberOfSets * 2)
    }
}
