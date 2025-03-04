//
//  EditReminderView.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct EditReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    let reminderStore: ReminderStore
    let reminder: Reminder
    
    @State private var title: String
    @State private var description: String
    @State private var date: Date
    @State private var repeatOption: Reminder.RepeatOption
    @State private var priority: Reminder.Priority
    
    init(reminderStore: ReminderStore, reminder: Reminder) {
        self.reminderStore = reminderStore
        self.reminder = reminder
        
        // Initialize state properties with the reminder's values
        _title = State(initialValue: reminder.title)
        _description = State(initialValue: reminder.description)
        _date = State(initialValue: reminder.date)
        _repeatOption = State(initialValue: reminder.repeat)
        _priority = State(initialValue: reminder.priority)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Edit Reminder")
                    .font(.headline)
                    .padding()
                Spacer()
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing, 10)
                
                Button("Save") {
                    saveUpdatedReminder()
                }
                .disabled(title.isEmpty)
                .padding(.trailing)
            }
            .padding(.top, 10)
            
            Divider()
            
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("When")) {
                    DatePicker("Date and Time", selection: $date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .environment(\.locale, Locale(identifier: "en_US_POSIX"))
                }
                
                Section(header: Text("Repeat")) {
                    Picker("Frequency", selection: $repeatOption) {
                        ForEach(Reminder.RepeatOption.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                        }
                    }
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority Level", selection: $priority) {
                        ForEach(Reminder.Priority.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.horizontal, 20) // Add horizontal padding to the Form
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 500, height: 550)
    }
    
    private func saveUpdatedReminder() {
        let updatedReminder = Reminder(
            id: reminder.id,
            title: title,
            description: description,
            date: date,
            repeat: repeatOption,
            priority: priority,
            completed: reminder.completed,
            createdAt: reminder.createdAt
        )
        
        reminderStore.updateReminder(updatedReminder)
        presentationMode.wrappedValue.dismiss()
    }
}
