//
//  AZAuxiliary.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/30/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import HealthKit
import UserNotifications

let unCenter = UNUserNotificationCenter.current()

typealias AZMetadata = [String : Any]

let hkStore = HKHealthStore()

extension HKDevice {
    static let omronHEM6111 = HKDevice(name: "Electronic Blood Pressure Monitor", manufacturer: "OMRON", model: "HEM-6111", hardwareVersion: nil, firmwareVersion: nil, softwareVersion: nil, localIdentifier: nil, udiDeviceIdentifier: nil)
}

extension HKUnit {
    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: .minute())
    }
}
