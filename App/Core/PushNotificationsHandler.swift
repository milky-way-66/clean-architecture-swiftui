//
//  PushNotificationsHandler.swift
//  App
//

import UserNotifications

protocol PushNotificationsHandler { }

final class RealPushNotificationsHandler: NSObject, PushNotificationsHandler {

    private let deepLinksHandler: DeepLinksHandler

    init(deepLinksHandler: DeepLinksHandler) {
        self.deepLinksHandler = deepLinksHandler
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension RealPushNotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo, completionHandler: completionHandler)
    }

    /// Map an APNs payload to a `DeepLink`.
    ///
    /// As a template, this decodes a `"deepLink"` string from `aps`.
    /// Replace with the schema your backend sends.
    func handleNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        guard
            let payload = userInfo["aps"] as? [AnyHashable: Any],
            let urlString = payload["deepLink"] as? String,
            let url = URL(string: urlString),
            let deepLink = DeepLink(url: url)
        else {
            completionHandler()
            return
        }
        Task { @MainActor in
            deepLinksHandler.open(deepLink: deepLink)
            completionHandler()
        }
    }
}
