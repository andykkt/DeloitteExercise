//
//  AppConstants.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

// MARK: - Constants

class AppConstants {
    static var apiKey: String = "043a35289f019f2c229cefce0d4d4976"
    static var apiBaseURL: String = "https://api.flickr.com"
}

enum AppStorageKey {
    static let kIsOnboarded = "isOnboarded"
    static let kHistory = "history"
}

extension Color {
    static let mainBackground = Color("mainBackground")
    static let flickrPink = Color("flickrPink")
    static let flickrBlue = Color("flickrBlue")
}

struct FlickrFontModifier: ViewModifier {
    enum TextStyle {
        case logo, title, body, caption, button
        var value: (size: CGFloat, weight: Font.Weight) {
            switch self {
            case .title: return (17, .bold)
            case .body: return (14, .regular)
            case .caption: return (12, .regular)
            case .button: return (14, .bold)
            case .logo: return (32, .medium)
            }
        }
    }
    var style: TextStyle = .body
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: style.value.size, weight: style.value.weight, design: .default))
    }
}

extension View {
    func flickrFont(style: FlickrFontModifier.TextStyle) -> some View {
        self.modifier(FlickrFontModifier(style: style))
    }
}
