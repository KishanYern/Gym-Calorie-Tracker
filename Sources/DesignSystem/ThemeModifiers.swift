import SwiftUI

struct BackgroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0x0a0a0f),
                        Color.backgroundBase,
                        Color.backgroundDeep
                    ]),
                    center: .top,
                    startRadius: 0,
                    endRadius: 800
                )
                .ignoresSafeArea()
            )
    }
}

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.surface)
            .cornerRadius(Theme.Radius.large)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.large)
                    .stroke(Color.borderDefault, lineWidth: 1)
            )
            // Approximate multi-layer shadow
            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 2)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

struct GlowButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(configuration.isPressed ? Color.accentBright : Color.accentTheme)
            .cornerRadius(Theme.Radius.small)
            .shadow(color: Color.accentGlow, radius: configuration.isPressed ? 4 : 8, x: 0, y: configuration.isPressed ? 2 : 4)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.small)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .blendMode(.overlay)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(Theme.Animation.quick, value: configuration.isPressed)
    }
}

struct ThemeTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color(hex: 0x0F0F12))
            .cornerRadius(Theme.Radius.small)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.small)
                    .stroke(Color.borderDefault, lineWidth: 1)
            )
            .foregroundColor(.foregroundTheme)
    }
}
