//
//  NotificationManager.swift
//  SmartPlannerApp
//
//  Created by csuftitan on 4/10/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    // Asks the iPhone for permission to pop up on the lock screen
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications allowed by user.")
            } else if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedules the actual alarm
    func scheduleReminder(for milestone: Milestone) {
        let content = UNMutableNotificationContent()
        content.title = "Milestone Due Tomorrow!"
        content.body = "Time to focus on: \(milestone.title)"
        content.sound = .default
        
        // Math to subtract exactly 24 hours from the due date
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -24, to: milestone.dueDate) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        
        // Create the trigger and hand it to the iPhone's notification center
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: milestone.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule: \(error.localizedDescription)")
            }
        }
    }
}
