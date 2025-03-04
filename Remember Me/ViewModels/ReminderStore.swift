//
//  ReminderStore.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import Foundation
import Combine

class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = []
    
    private let saveKey = "reminders"
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadReminders()
    }
    
    func loadReminders() {
        if let data = userDefaults.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
                self.reminders = decoded
                return
            }
        }
        
        // Set empty array if no data found
        self.reminders = []
    }
    
    func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            userDefaults.set(encoded, forKey: saveKey)
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
        
        // Schedule notification
        NotificationManager.shared.scheduleNotification(for: reminder)
    }
    
    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            // Cancel the old notification and schedule a new one
            NotificationManager.shared.cancelNotification(for: reminder.id)
            NotificationManager.shared.scheduleNotification(for: reminder)
            
            reminders[index] = reminder
            saveReminders()
        }
    }
    
    func deleteReminder(at indexSet: IndexSet) {
        reminders.remove(atOffsets: indexSet)
        saveReminders()
    }
    
    func completeReminder(id: String) {
        if let index = reminders.firstIndex(where: { $0.id == id }) {
            reminders[index].completed = true
            saveReminders()
        }
    }
    
    // Add this to ReminderStore.swift
    var upcomingReminders: [Reminder] {
        let today = Date()
        return reminders
            .filter { !$0.completed && $0.date > today }
            .sorted { $0.date < $1.date }
            .prefix(5)
            .map { $0 }
    }
}
