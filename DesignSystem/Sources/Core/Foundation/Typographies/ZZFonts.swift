//
//  ZZFonts.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

// swiftlint:disable all

#if os(macOS)
import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
public typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// Template: Defined by app
// swiftlint:disable identifier_name line_length type_body_length
public enum ZZFonts: Sendable {

    public enum Poppins: Sendable {

        public static let black = FontConvertible(name: "Poppins-Black", family: "Poppins", path: "Poppins-Black.ttf")
        public static let blackItalic = FontConvertible(name: "Poppins-BlackItalic", family: "Poppins", path: "Poppins-BlackItalic.ttf")
        public static let bold = FontConvertible(name: "Poppins-Bold", family: "Poppins", path: "Poppins-Bold.ttf")
        public static let boldItalic = FontConvertible(name: "Poppins-BoldItalic", family: "Poppins", path: "Poppins-BoldItalic.ttf")
        public static let extraBold = FontConvertible(name: "Poppins-ExtraBold", family: "Poppins", path: "Poppins-ExtraBold.ttf")
        public static let extraBoldItalic = FontConvertible(name: "Poppins-ExtraBoldItalic", family: "Poppins", path: "Poppins-ExtraBoldItalic.ttf")
        public static let extraLight = FontConvertible(name: "Poppins-ExtraLight", family: "Poppins", path: "Poppins-ExtraLight.ttf")
        public static let extraLightItalic = FontConvertible(name: "Poppins-ExtraLightItalic", family: "Poppins", path: "Poppins-ExtraLightItalic.ttf")
        public static let italic = FontConvertible(name: "Poppins-Italic", family: "Poppins", path: "Poppins-Italic.ttf")
        public static let light = FontConvertible(name: "Poppins-Light", family: "Poppins", path: "Poppins-Light.ttf")
        public static let lightItalic = FontConvertible(name: "Poppins-LightItalic", family: "Poppins", path: "Poppins-LightItalic.ttf")
        public static let medium = FontConvertible(name: "Poppins-Medium", family: "Poppins", path: "Poppins-Medium.ttf")
        public static let mediumItalic = FontConvertible(name: "Poppins-MediumItalic", family: "Poppins", path: "Poppins-MediumItalic.ttf")
        public static let regular = FontConvertible(name: "Poppins-Regular", family: "Poppins", path: "Poppins-Regular.ttf")
        public static let semiBold = FontConvertible(name: "Poppins-SemiBold", family: "Poppins", path: "Poppins-SemiBold.ttf")
        public static let semiBoldItalic = FontConvertible(name: "Poppins-SemiBoldItalic", family: "Poppins", path: "Poppins-SemiBoldItalic.ttf")
        public static let thin = FontConvertible(name: "Poppins-Thin", family: "Poppins", path: "Poppins-Thin.ttf")
        public static let thinItalic = FontConvertible(name: "Poppins-ThinItalic", family: "Poppins", path: "Poppins-ThinItalic.ttf")

        public static let all: [FontConvertible] = [
            black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic,
            extraLight, extraLightItalic, italic, light, lightItalic, medium,
            mediumItalic, regular, semiBold, semiBoldItalic, thin, thinItalic
        ]
    }

    public static let allCustomFonts: [FontConvertible] = [Poppins.all].flatMap { $0 }

    public static func registerAllCustomFonts() {
        allCustomFonts.forEach { $0.registerIfNeeded() }
    }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct FontConvertible: Sendable {
    public let name: String
    public let family: String
    public let path: String

#if os(macOS)
    public typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
    public typealias Font = UIFont
#endif

    public func font(size: CGFloat) -> Font {
        guard let font = Font(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }

#if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    public func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(self, size: size)
    }

    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
    public func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font.custom(self, fixedSize: fixedSize)
    }

    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
    public func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
        SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
    }
#endif

    public func register() {
        // swiftlint:disable:next conditional_returns_on_newline
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    fileprivate func registerIfNeeded() {
#if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: family).contains(name) {
            register()
        }
#elseif os(macOS)
        if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            register()
        }
#endif
    }

    fileprivate var url: URL? {
        // swiftlint:disable:next implicit_return
        Bundle.module.url(forResource: path, withExtension: nil)
    }
}

public extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
        font.registerIfNeeded()
        self.init(name: font.name, size: size)
    }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Font {
    static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, size: size)
    }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public extension SwiftUI.Font {
    static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, fixedSize: fixedSize)
    }

    static func custom(
        _ font: FontConvertible,
        size: CGFloat,
        relativeTo textStyle: SwiftUI.Font.TextStyle
    ) -> SwiftUI.Font {
        font.registerIfNeeded()
        return custom(font.name, size: size, relativeTo: textStyle)
    }
}
#endif

