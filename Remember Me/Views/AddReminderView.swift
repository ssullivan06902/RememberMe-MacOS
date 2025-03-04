//
//  AddReminderView.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

struct AddReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    let reminderStore: ReminderStore
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var repeatOption = Reminder.RepeatOption.none
    @State private var priority = Reminder.Priority.medium
    
    var body: some View {
        VStack {
            HStack {
                Text("Add Reminder")
                    .font(.headline)
                    .padding()
                Spacer()
                
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing, 10)
                
                Button("Save") {
                    saveReminder()
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
    
    private func saveReminder() {
        let newReminder = Reminder(
            title: title,
            description: description,
            date: date,
            repeat: repeatOption,
            priority: priority
        )
        
        reminderStore.addReminder(newReminder)
        presentationMode.wrappedValue.dismiss()
    }
}
