//
//  TextStyle.swift
//  Coin strike car
//
//


import SwiftUI

enum TextStyle {
    case h1
    case h2
    case h3
    case text
    
}

extension TextStyle {
    var font: Font {
        switch self {
        case .h1:
            return .system(size: 24, weight: .bold)
        case .h2:
            return .system(size: 20, weight: .semibold)
        case .h3:
            return .system(size: 16, weight: .semibold)
        case .text:
            return .system(size: 16, weight: .regular)
        
        }
    }
}
