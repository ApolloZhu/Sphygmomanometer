//
//  AZProcess.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/30/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import HealthKit

enum AZError: Error {
    case noBloodPressure(Error)
    case noHeartRate(Error)
    case unmatchCount(Int, Int)
}

extension AZSphygmomanometerSample {
    func store() {
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
            return HKCorrelation(type: type, start: date, end: date, objects: [systolicSample, diastolicSample], device: .omronHEM6111, metadata: metadata)
        }()

        let heartRateSample: HKQuantitySample = {
            let type = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let quantity = HKQuantity(unit: .beatsPerMinute(), doubleValue: Double(pulse))
            return HKQuantitySample(type: type, quantity: quantity, start: date, end: date, device: .omronHEM6111, metadata: metadata)
        }()

        hkStore.save([heartRateSample, bloodPressureCorrelation]) { print($0 ? "Data Saved" : $1!) }
    }

    static func fetchAll(_ handler: @escaping ([AZSphygmomanometerSample]?, AZError?) -> Void) {
        let query = HKCorrelationQuery(type: HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!, predicate: nil, samplePredicates: nil) { _, correlations, error in
            guard error == nil, let correlations = correlations else {
                return handler(nil, .noBloodPressure(error!))
            }
            let query = HKSampleQuery.init(sampleType: HKQuantityType.quantityType(forIdentifier: .heartRate)!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                guard error == nil, let samples = samples else {
                    return handler(nil, .noHeartRate(error!))
                }
                guard correlations.count == samples.count else {
                    return handler(nil, .unmatchCount(correlations.count, samples.count))
                }
                let output: [AZSphygmomanometerSample] = zip(correlations, samples).enumerated().map {
                    let (index, (correlation, heartRate)) = $0
                    let systolicSample = correlation.objects(for: HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!).first! as! HKQuantitySample
                    let systolic = Int(systolicSample.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                    let diastolicSample = correlation.objects(for: HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!).first! as! HKQuantitySample
                    let diastolic = Int(diastolicSample.quantity.doubleValue(for: HKUnit.millimeterOfMercury()))
                    let pulseSample = heartRate as! HKQuantitySample
                    let pulse = Int(pulseSample.quantity.doubleValue(for: .beatsPerMinute()))
                    let date = pulseSample.startDate
                    return AZSphygmomanometerSample(systolic: systolic, diastolic: diastolic, pulse: pulse, bodyPosition: AZBodyPossition(rawValue: index % 3)!, date: date)
                }
                handler(output, nil)
            }
            hkStore.execute(query)
        }
        hkStore.execute(query)
    }
}
