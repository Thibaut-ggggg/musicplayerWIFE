import SwiftUI

/// NeonPod's Y2K / Frutiger Aero palette. Tweak these colors to customize the theme.
/// All values are sRGB and require no external assets or frameworks.
enum NeonPalette {
    static let lime = Color(red: 167 / 255.0, green: 255 / 255.0, blue: 71 / 255.0)       // #A7FF47
    static let gloss = Color(red: 213 / 255.0, green: 255 / 255.0, blue: 128 / 255.0)     // #D5FF80
    static let deep = Color(red: 23 / 255.0, green: 42 / 255.0, blue: 20 / 255.0)         // #172A14
    static let display = Color(red: 7 / 255.0, green: 14 / 255.0, blue: 8 / 255.0)        // #070E08
    static let pink = Color(red: 255 / 255.0, green: 121 / 255.0, blue: 202 / 255.0)     // #FF79CA

    static let pearl = Color(red: 247 / 255.0, green: 255 / 255.0, blue: 230 / 255.0)
    static let fern = Color(red: 68 / 255.0, green: 143 / 255.0, blue: 36 / 255.0)
    static let edge = Color(red: 53 / 255.0, green: 125 / 255.0, blue: 27 / 255.0)

    /// Glossy plastic, with a lighter top lip and saturated lower casing.
    static let shellGradient = LinearGradient(
        stops: [
            .init(color: gloss, location: 0),
            .init(color: lime, location: 0.20),
            .init(color: Color(red: 0.49, green: 0.92, blue: 0.21), location: 0.70),
            .init(color: fern, location: 1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
