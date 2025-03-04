//
//  ContentView.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var reminderStore = ReminderStore()
    @State private var showingAddReminder = false
    @State private var reminderToEdit: Reminder? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(reminderStore.reminders) { reminder in
                    ReminderRow(reminder: reminder)
                        .contextMenu {
                            Button(action: {
                                reminderStore.completeReminder(id: reminder.id)
                            }) {
                                Label("Complete", systemImage: "checkmark.circle")
                            }
                            
                            Button(action: {
                                reminderToEdit = reminder
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                deleteReminder(reminder)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            reminderToEdit = reminder
                        }
                }
                .onDelete(perform: reminderStore.deleteReminder)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddReminder = true }) {
                        Label("Add Reminder", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(reminderStore: reminderStore)
            }
            .sheet(item: $reminderToEdit) { reminder in
                EditReminderView(reminderStore: reminderStore, reminder: reminder)
            }
        }
    }
    
    private func deleteReminder(_ reminder: Reminder) {
        if let index = reminderStore.reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminderStore.deleteReminder(at: IndexSet(integer: index))
        }
    }
}
