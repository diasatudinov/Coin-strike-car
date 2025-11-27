import SwiftUI

enum TextStyle {
    case h1
    case h2
    case body
    case caption
}

extension TextStyle {
    var font: Font {
        switch self {
        case .h1:
            return .system(size: 24, weight: .medium)
        case .h2:
            return .system(size: 20, weight: .semibold)
        case .body:
            return .system(size: 16, weight: .regular)
        case .caption:
            return .system(size: 12, weight: .regular)
        }
    }
}