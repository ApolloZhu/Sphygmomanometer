//
//  AZDataType.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/29/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import HealthKit

let AZMetadataKeyBodyPosition = "Body Position"

enum AZBodyPossition: Int, CustomStringConvertible {
    case lie = 0, sit, stand
    var description: String {
        switch self {
        case .lie: return "Lying"
        case .sit: return "Sitting"
        case .stand: return "Standing"
        }
    }
}

struct AZSphygmomanometerSample {
    let systolic: Int
    let diastolic: Int
    let pulse: Int
    let bodyPosition: AZBodyPossition
    let date: Date
}

extension AZSphygmomanometerSample: CustomStringConvertible {
    var description: String {
        return """
        Blood Pressure: \(systolic)/\(diastolic) mmHg
        Heart Rate: \(pulse) beats per minute
        Body Position: \(bodyPosition)\n
        """
    }
}
