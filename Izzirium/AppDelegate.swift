//
//  AppDelegate.swift
//  GrandTour
//
//  Created by Benjamin Lambert on 11/06/2025.
//

import Data
import DesignSystem
import Domain
import Kastor
import SKDependencyInjection
import SwiftUI
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    // Singleton instance of AppDelegate
    private(set) static var instance: AppDelegate?

    // MARK: - Dependency injection

    // MARK: - Properties

    // Logger
    private let logger = Logger(category: AppDelegate.self)

    // MARK: - UIApplicationDelegate

    // swiftlint:disable discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the singleton instance of AppDelegate
        AppDelegate.instance = self

        setupKastor()
        
        logger.info("App Finish Launching")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Private methods

    /// Sets up the Kastor framework with the specified configuration.
    private func setupKastor() {
        // Configure the Kastor framework with the provided settings
        KastorManager.setup(
            configuration: KastorConstants.kastorConfiguration
        )
    }
}
