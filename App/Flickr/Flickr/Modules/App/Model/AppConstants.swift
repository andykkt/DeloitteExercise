//
//  AppConstants.swift
//  Flickr
//
//  Created by Andy Kim on 5/3/21.
//

import SwiftUI

// MARK: - Constants

class AppConstants {
    static var apiKey: String = "96358825614a5d3b1a1c3fd87fca2b47"
    static var apiBaseURL: String = "https://api.flickr.com"
}

enum AppStorageKey {
    static let kIsOnboarded = "isOnboarded"
    static let kHistory = "history"
}

extension Color {
    static let mainBackground = Color("mainBackground")
}

struct MarkProFontModifier: ViewModifier {
    enum TextStyle {
        case title, body, button, smallButton, smallBody, accentBody,
             alertTitle, mainCategory, subCategory,
             transcriptionBody, transcriptionSmall, timeStamp, timeStampSmall, accentSmall,
             inputTitle, sectionTitle, notificationTitle, notificationBody,
             smallMainCategory, smallSubCategory, termsAndConditionBody
        var value: (size: CGFloat, weight: Font.Weight) {
            switch self {
            case .title: return (17, .bold)
            case .body: return (14, .regular)
            case .button: return (14, .bold)
            case .smallBody: return (12, .regular)
            case .smallButton: return (12, .bold)
            case .accentBody: return (13, .medium)
            case .accentSmall: return (13, .regular)
            case .alertTitle: return (16, .bold)
            case .mainCategory: return (14, .bold)
            case .subCategory: return (14, .regular)
            case .transcriptionBody: return (16, .medium)
            case .transcriptionSmall: return (10, .medium)
            case .timeStamp: return (12, .medium)
            case .timeStampSmall: return (10, .medium)
            case .inputTitle: return (16, .regular)
            case .sectionTitle: return (26, .heavy)
            case .notificationBody: return (17, .regular)
            case .notificationTitle: return (22, .bold)
            case .smallMainCategory: return (12, .bold)
            case .smallSubCategory: return (12, .regular)
            case .termsAndConditionBody: return (16, .regular)
            }
        }
    }
    var style: TextStyle = .body
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("MarkPro", size: style.value.size).weight(style.value.weight))
        
    }
    
    static func getUIFont(style: TextStyle) -> UIFont {
        let fontName: String
        switch style.value.weight {
        case .ultraLight: fontName = "MarkPro-Thin"
        case .thin: fontName = "MarkPro-Thin"
        case .light: fontName = "MarkPro-Thin"
        case .regular: fontName = "MarkPro"
        case .medium: fontName = "MarkPro-Medium"
        case .semibold: fontName = "MarkPro-Medium"
        case .bold: fontName = "MarkPro-Bold"
        case .heavy: fontName = "MarkPro-Heavy"
        case .black: fontName = "MarkPro-Black"
        default: fontName = "MarkPro"
        }
        return UIFont(name: fontName, size: style.value.size) ?? UIFont.systemFont(ofSize: style.value.size)
    }
}

extension View {
    func markProFont(style: MarkProFontModifier.TextStyle) -> some View {
        self.modifier(MarkProFontModifier(style: style))
    }
}
