import SwiftUI

extension Color {
    static let backgroundDeep = Color(hex: 0x020203)
    static let backgroundBase = Color(hex: 0x050506)
    static let backgroundElevated = Color(hex: 0x0a0a0c)
    
    static let surface = Color.white.opacity(0.05)
    static let surfaceHover = Color.white.opacity(0.08)
    
    static let foregroundTheme = Color(hex: 0xEDEDEF)
    static let foregroundMuted = Color(hex: 0x8A8F98)
    static let foregroundSubtle = Color.white.opacity(0.60)
    
    static let accentTheme = Color(hex: 0x5E6AD2)
    static let accentBright = Color(hex: 0x6872D9)
    static let accentGlow = Color(hex: 0x5E6AD2).opacity(0.3)
    
    static let borderDefault = Color.white.opacity(0.06)
    static let borderHover = Color.white.opacity(0.10)
    static let borderAccent = Color(hex: 0x5E6AD2).opacity(0.30)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
