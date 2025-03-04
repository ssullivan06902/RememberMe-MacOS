//
//  ThemeManager.swift
//  Remember Me
//
//  Created by Sean Sullivan on 3/4/25.
//
import SwiftUI

enum AppTheme: String {
    case light, dark, system
}

class ThemeManager: ObservableObject {
    @AppStorage("appTheme") var currentTheme: AppTheme = .system {
        didSet {
            applyTheme()
        }
    }
    
    init() {
        applyTheme()
    }
    
    func applyTheme() {
        switch currentTheme {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .system:
            NSApp.appearance = nil
        }
    }
}
