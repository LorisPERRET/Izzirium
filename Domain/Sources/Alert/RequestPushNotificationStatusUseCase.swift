//
//  RequestPushNotificationStatusUseCase.swift
//  Domain
//
//  Created by Loris Perret on 31/03/2026.
//

import SKDependencyInjection
import UserNotifications
import UIKit

@MainActor
public protocol RequestPushNotificationStatusUseCaseProtocol: Sendable {

    func perform() async -> Bool?
}

final class RequestPushNotificationStatusUseCase: RequestPushNotificationStatusUseCaseProtocol {

    // MARK: RequestPushNotificationStatusUseCaseProtocol

    func perform() async -> Bool? {
        let result = await UNUserNotificationCenter.current().notificationSettings()
        switch result.authorizationStatus {
        case .notDetermined:
            return nil
        case .denied:
            return false
        case .authorized:
            return true
        case .provisional:
            return true
        case .ephemeral:
            return true
        @unknown default:
            return nil
        }
    }
}

extension InjectedValues {

    @Inject public var requestPushNotificationStatusUseCase: RequestPushNotificationStatusUseCaseProtocol = RequestPushNotificationStatusUseCase()
}
