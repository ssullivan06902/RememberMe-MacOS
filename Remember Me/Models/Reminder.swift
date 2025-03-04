//
//  Reminder.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import Foundation

struct Reminder: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var date: Date
    var `repeat`: RepeatOption
    var priority: Priority
    var completed: Bool = false
    var createdAt: Date = Date()
    
    enum RepeatOption: String, Codable, CaseIterable {
        case none = "none"
        case daily = "daily"
        case weekdays = "weekdays"
        case weekly = "weekly"
        case monthly = "monthly"
        case yearly = "yearly"
    }
    
    enum Priority: String, Codable, CaseIterable {
        case low = "low"
        case medium = "medium"
        case high = "high"
    }
}
