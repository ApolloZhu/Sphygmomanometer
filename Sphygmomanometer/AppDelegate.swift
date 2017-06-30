//
//  AppDelegate.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/29/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import HealthKit
import UIKit
import UserNotifications

let AZHourlyNotificatoinIdentifier = "Sphygmomanometer-Hourly"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let requestTypes =
            Set([.bloodPressureSystolic, .bloodPressureDiastolic, .heartRate]
                .flatMap { HKQuantityType.quantityType(forIdentifier: $0) })
        hkStore.requestAuthorization(toShare: requestTypes, read: requestTypes)
        { _,_ in }
        unCenter.requestAuthorization(options: [.badge, .sound, .alert]) { _,_ in }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time for Measurement", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "It's better to keep track of your data!", arguments: nil)
        content.badge = 1
        content.sound = .default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60, repeats: true)
        let request = UNNotificationRequest(identifier: AZHourlyNotificatoinIdentifier, content: content, trigger: trigger)
        unCenter.add(request) { _ in }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        unCenter.removePendingNotificationRequests(withIdentifiers: [AZHourlyNotificatoinIdentifier])
        unCenter.removeDeliveredNotifications(withIdentifiers: [AZHourlyNotificatoinIdentifier])
        application.applicationIconBadgeNumber = 0
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound])
    }

}

