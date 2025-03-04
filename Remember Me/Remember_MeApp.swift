//
//  Remember_MeApp.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

@main
struct RememberMeApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var reminderStore = ReminderStore()
    
    @State private var statusBar: StatusBarController?
    
    init() {
        // Request notification permissions
        NotificationManager.shared.requestPermission { granted in
            print("Notification permission granted: \(granted)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(reminderStore)
                .accentColor(Color("AccentColor"))
                .onAppear {
                    setupStatusBar()
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
            
            CommandGroup(after: .appSettings) {
                Picker("Appearance", selection: $themeManager.currentTheme) {
                    Text("System").tag(AppTheme.system)
                    Text("Light").tag(AppTheme.light)
                    Text("Dark").tag(AppTheme.dark)
                }
            }
        }
    }
    
    func setupStatusBar() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: StatusBarView(reminderStore: reminderStore)
                .environmentObject(themeManager)
                .accentColor(Color("AccentColor"))
        )
        
        statusBar = StatusBarController(popover: popover)
    }
}
