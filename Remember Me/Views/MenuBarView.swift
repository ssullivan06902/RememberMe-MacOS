//
//  MenuBarView.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct MenuBarView: View {
    @ObservedObject var reminderStore: ReminderStore
    @State private var showingAddReminder = false
    
    var body: some View {
        VStack {
            Text("Upcoming Reminders")
                .font(.headline)
                .padding(.top)
            
            Divider()
            
            if reminderStore.reminders.isEmpty {
                Text("No reminders")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(reminderStore.upcomingReminders) { reminder in
                        VStack(alignment: .leading) {
                            Text(reminder.title)
                                .fontWeight(.medium)
                            
                            Text(formatDate(reminder.date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .frame(maxHeight: 300)
            }
            
            Divider()
            
            HStack {
                Button("Add New") {
                    showingAddReminder = true
                }
                
                Spacer()
                
                Button("Open App") {
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
            .padding()
        }
        .frame(width: 300)
        .sheet(isPresented: $showingAddReminder) {
            AddReminderView(reminderStore: reminderStore)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }
}
