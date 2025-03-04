//
//  NotificationManager.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            completion(granted)
        }
    }
    
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.description.isEmpty ? "Your reminder is due!" : reminder.description
        content.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "reminder-\(reminder.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for reminderId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminder-\(reminderId)"])
    }
}
