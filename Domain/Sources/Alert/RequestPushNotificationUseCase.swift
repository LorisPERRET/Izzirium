//
//  RequestPushNotificationUseCase.swift
//  Domain
//
//  Created by Loris Perret on 31/03/2026.
//

import SKDependencyInjection
import UserNotifications
import UIKit

@MainActor
public protocol RequestPushNotificationUseCaseProtocol: Sendable {

    func perform() async throws
}

final class RequestPushNotificationUseCase: RequestPushNotificationUseCaseProtocol {

    // MARK: RequestPushNotificationUseCaseProtocol

    func perform() async throws {
        try await UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound])

        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension InjectedValues {

    @Inject public var requestPushNotificationUseCase: RequestPushNotificationUseCaseProtocol = RequestPushNotificationUseCase()
}
