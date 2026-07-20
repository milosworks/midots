pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    // --- Backgrounds & Containers ---
    // Absolute bottom layer
    property alias bgBase: adapter.bgBase
    // Containers
    property alias surface: adapter.surface
    // Secondary, inactive elements
    property alias surfaceVariant: adapter.surfaceVariant
    // Softer, lower-emphasis version of the primary color for backgrounds/cards
    property alias primaryContainer: adapter.primaryContainer
    
    // --- Typography & Foreground ---
    // Primary legible text
    property alias textPrimary: adapter.textPrimary
    // Diminished/inactive text
    property alias textMuted: adapter.textMuted
    // Text/icon color that sits inside the primary container
    property alias textOnPrimaryContainer: adapter.textOnPrimaryContainer
    
    // --- Accents & Interactive States ---
    // Main highlight color
    property alias primary: adapter.primary
    // Text/icon color that sits inside the primary accent
    property alias textOnPrimary: adapter.textOnPrimary
    // Secondary accent color, used for less prominent highlights
    property alias secondary: adapter.secondary
    // Tertiary accent color, used for contrasting accents
    property alias tertiary: adapter.tertiary
    
    // --- Status & Actions ---
    // For deletions, warnings, or destructive actions
    property alias error: adapter.error

    property var watcher: FileView {
        path: Quickshell.env("HOME") + "/.cache/mish/colors.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        
        JsonAdapter {
            id: adapter

            // Default fallbacks (Catppuccin Mocha)
            property color bgBase: "#1E1E2E" 
            property color surface: "#313244" 
            property color surfaceVariant: "#45475A" 
            
            property color textPrimary: "#CDD6F4" 
            property color textMuted: "#A6ADC8" 
            property color textOnPrimaryContainer: "#11111B"
            
            property color primary: "#89B4FA" 
            property color textOnPrimary: "#11111B" 
            
            property color primaryContainer: "#B4BEFE" 
            property color secondary: "#F5C2E7" 
            property color tertiary: "#94E2D5" 
            
            property color error: "#F38BA8"
        }
    }
}