//
//  AppDelegate.swift
//  Sphygmomanometer
//
//  Created by Apollo Zhu on 6/29/17.
//  Copyright © 2017 WWITDC. All rights reserved.
//

import UIKit
import UserNotifications
import HealthKit

let AZHourlyNotificatoinIdentifier = "Sphygmomanometer-Hourly"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let requestTypes =
            Set([.bloodPressureSystolic, .bloodPressureDiastolic, .heartRate]
                .flatMap { HKQuantityType.quantityType(forIdentifier: $0) })
        healthStore.requestAuthorization(toShare: requestTypes, read: requestTypes)
        { _,_ in }
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _,_ in }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time for Measurement", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "It's better to keep track of your data!", arguments: nil)
        content.badge = 1
        content.sound = .default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60, repeats: true)
        let request = UNNotificationRequest(identifier: AZHourlyNotificatoinIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { _ in }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [AZHourlyNotificatoinIdentifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [AZHourlyNotificatoinIdentifier])
        application.applicationIconBadgeNumber = 0
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound])
    }

}

