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
    mutating func nextPose() -> Pose
}

extension ExercisePose {
    var currentPose: Pose {
        return poses[currentPoseIndex]
    }
    
    mutating func nextPose() -> Pose {
        currentPoseIndex += 1
        remaningSets = remaningSets - (currentPoseIndex - 1) % poses.count
        return poses[(currentPoseIndex - 1) % poses.count]
    }
}

struct WeightPose: ExercisePose {
    var remaningSets = 5
    var numberOfSets = 5
    var currentPoseIndex = 0
    var poses: [Pose]
    var currentPose: Pose {
        return poses[(currentPoseIndex) % poses.count]
    }
}
