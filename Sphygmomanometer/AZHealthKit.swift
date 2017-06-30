//
//  AZHealthKit.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/29/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import Foundation
import HealthKit

let device = HKDevice(name: "Electronic Blood Pressure Monitor", manufacturer: "OMRON", model: "HEM-6111", hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
let healthStore = HKHealthStore()

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
}

extension AZSphygmomanometerSample: CustomStringConvertible {
    var description: String {
        return """
        Blood Pressure: \(systolic)/\(diastolic) mmHg
        Heart Rate: \(pulse) beats per minute
        Body Position: \(bodyPosition)
        """
    }
}

typealias AZMetadata = [String : Any]

let AZMetadataKeyBodyPosition = "Body Position"

extension AZSphygmomanometerSample {
    func store(date: Date? = nil) {
        let date = date ?? Date()
        let metadata: AZMetadata = [
            AZMetadataKeyBodyPosition : "\(bodyPosition)",
            HKMetadataKeyHeartRateSensorLocation : HKHeartRateSensorLocation.wrist.rawValue,
            HKMetadataKeyWasUserEntered: true
        ]
        
        let bloodPressureCorrelation: HKCorrelation = {
            let systolicSample: HKQuantitySample = {
                let type = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
                let quantity = HKQuantity(unit: .millimeterOfMercury(), doubleValue: Double(systolic))
                return HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            }()
            
            let diastolicSample: HKQuantitySample = {
                let type = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
                let quantity = HKQuantity(unit: .millimeterOfMercury(), doubleValue: Double(diastolic))
                return HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            }()
            
            let type = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
            return HKCorrelation(type: type, start: date, end: date, objects: [systolicSample, diastolicSample], device: device, metadata: metadata)
        }()

        let heartRateSample: HKQuantitySample = {
            let type = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let quantity = HKQuantity(unit: .beatsPerMinute(), doubleValue: Double(pulse))
            return HKQuantitySample(type: type, quantity: quantity, start: date, end: date, device: device, metadata: metadata)
        }()
        
        healthStore.save([heartRateSample, bloodPressureCorrelation]) { _,_ in }
    }
}

extension HKUnit {
    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: .minute())
    }
}
