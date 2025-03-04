//
//  StatusBarView.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct StatusBarView: View {
    @ObservedObject var reminderStore: ReminderStore
    @State private var showingAddReminder = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Remember Me")
                .font(.headline)
                .padding(.top)
                .padding(.leading) // Add this line for left padding
            
            Divider()
            
            if reminderStore.upcomingReminders.isEmpty {
                Text("No upcoming reminders")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    Section(header: Text("Upcoming")) {
                        ForEach(reminderStore.upcomingReminders) { reminder in
                            HStack {
                                Circle()
                                    .fill(priorityColor(reminder.priority))
                                    .frame(width: 8, height: 8)
                                
                                VStack(alignment: .leading) {
                                    Text(reminder.title)
                                        .fontWeight(.medium)
                                    
                                    Text(formatDate(reminder.date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .frame(height: min(CGFloat(reminderStore.upcomingReminders.count * 60), 300))
            }
            
            Divider()
            
            HStack {
                Button("Add New") {
                    showingAddReminder = true
                }
                
                Spacer()
                
                Button("Open App") {
                    NSApp.activate(ignoringOtherApps: true)
                    if let window = NSApp.windows.first {
                        window.makeKeyAndOrderFront(nil)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(width: 300)
        .sheet(isPresented: $showingAddReminder) {
            AddReminderView(reminderStore: reminderStore)
        }
    }
    
    private func priorityColor(_ priority: Reminder.Priority) -> Color {
        switch priority {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}
