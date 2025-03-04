import SwiftUI

@main
struct ReminderManagerApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var reminderStore = ReminderStore()
    
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
        
        // Add a MenuBarExtra scene
       // MenuBarExtra("Reminders", systemImage: "bell.fill") {
        MenuBarExtra("Reminders", image: "menu-bar-icon") {
            MenuBarView(reminderStore: reminderStore)
                .accentColor(Color("AccentColor"))
        }
        .menuBarExtraStyle(.window)
    }
}
