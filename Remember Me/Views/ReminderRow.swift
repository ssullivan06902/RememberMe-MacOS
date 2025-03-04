//
//  ReminderRow.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct ReminderRow: View {
    let reminder: Reminder
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(reminder.completed)
                
                if !reminder.description.isEmpty {
                    Text(reminder.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(formatDate(reminder.date))
                        .font(.caption)
                    
                    if reminder.repeat != .none {
                        Text("• \(reminder.repeat.rawValue)")
                            .font(.caption)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            priorityIndicator(reminder.priority)
        }
        .opacity(reminder.completed ? 0.6 : 1)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent formatting
        return formatter.string(from: date)
    }
    
    private func priorityIndicator(_ priority: Reminder.Priority) -> some View {
        let color: Color = {
            switch priority {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }()
        
        return Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }
}
