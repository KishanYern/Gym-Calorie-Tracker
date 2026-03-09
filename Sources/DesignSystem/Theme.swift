import SwiftUI

enum Theme {
    static let baseUnit: CGFloat = 4.0
    
    enum Radius {
        static let large: CGFloat = 16.0
        static let medium: CGFloat = 12.0
        static let small: CGFloat = 8.0
    }
    
    enum Animation {
        static let quick = SwiftUI.Animation.timingCurve(0.16, 1, 0.3, 1, duration: 0.2)
        static let standard = SwiftUI.Animation.timingCurve(0.16, 1, 0.3, 1, duration: 0.3)
    }
}
