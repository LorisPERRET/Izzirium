//
//  FontStyleDefinition.swift
//  DesignSystem
//
//  Created by Thibaut Schmitt on 24/02/2025.
//

// swiftlint:disable no_magic_numbers

extension FontStyle {

    // MARK: - All font styles

    public static let allFontStyles: [FontStyle] = [
        FontStyle.allHeadingFontStyles,
        FontStyle.allTextBoldFontStyles,
        FontStyle.allTextFontStyles,
        FontStyle.allTextMediumFontStyles,
        FontStyle.allTextSemiBoldFontStyles,
        FontStyle.allLabelFontStyles,
        FontStyle.allLinkFontStyles
    ].flatMap { $0 }

    // MARK: - Heading

    public static let allHeadingFontStyles: [FontStyle] = [
        .h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8
    ]

    public static let h1 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 60,
        lineHeight: 60,
        textStyle: .largeTitle
    )

    public static let h2 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 48,
        lineHeight: 48,
        textStyle: .largeTitle
    )

    public static let h3 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 36,
        lineHeight: 40,
        textStyle: .title2
    )

    public static let h4 = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 24,
        lineHeight: 32,
        textStyle: .title2
    )

    public static let h5 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 20,
        lineHeight: 28,
        textStyle: .title2
    )

    public static let h6 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 18,
        lineHeight: 28,
        textStyle: .title3
    )

    public static let h7 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 16,
        lineHeight: 24,
        textStyle: .title3
    )

    public static let h8 = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 14,
        lineHeight: 20,
        textStyle: .title3
    )

    // MARK: - Text

    public static let allTextFontStyles: [FontStyle] = [
        .textXL, .textL, .textBase, .textS, .textXS
    ]

    public static let textXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.regular,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let textL = FontStyle(
        fontConvertible: ZZFonts.Poppins.regular,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.regular,
        size: 16,
        lineHeight: 20,
        textStyle: .body
    )

    public static let textS = FontStyle(
        fontConvertible: ZZFonts.Poppins.regular,
        size: 14,
        lineHeight: 20,
        textStyle: .body
    )

    public static let textXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.regular,
        size: 12,
        lineHeight: 16,
        textStyle: .body
    )

    // MARK: - TextMedium

    public static let allTextMediumFontStyles: [FontStyle] = [
        .textMediumXL, .textMediumL, .textMediumBase, .textMediumS, .textMediumXS
    ]

    public static let textMediumXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let textMediumL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textMediumBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 16,
        lineHeight: 20,
        textStyle: .body
    )

    public static let textMediumS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 14,
        lineHeight: 16,
        textStyle: .body
    )

    public static let textMediumXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 12,
        lineHeight: 16,
        textStyle: .body
    )

    public static let textMediumXXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 8,
        lineHeight: 16,
        textStyle: .body
    )

    // MARK: - TextSemiBold

    public static let allTextSemiBoldFontStyles: [FontStyle] = [
        .textSemiBoldXL, .textSemiBoldL, .textSemiBoldBase, .textSemiBoldS, .textSemiBoldXS
    ]

    public static let textSemiBoldXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let textSemiBoldL = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textSemiBoldBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 16,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textSemiBoldS = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 14,
        lineHeight: 20,
        textStyle: .body
    )

    public static let textSemiBoldXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 12,
        lineHeight: 16,
        textStyle: .body
    )

    // MARK: - Text Bold

    public static let allTextBoldFontStyles: [FontStyle] = [
        .textBoldXL, .textBoldL, .textBoldBase, .textBoldS, .textBoldXS
    ]

    public static let textBoldXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let textBoldL = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textBoldBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 16,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textBoldS = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 14,
        lineHeight: 28,
        textStyle: .body
    )

    public static let textBoldXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.bold,
        size: 12,
        lineHeight: 24,
        textStyle: .body
    )

    // MARK: - Label

    public static let allLabelFontStyles: [FontStyle] = [
        .labelXL, .labelL, .labelBase, .labelS, .labelXS, .labelXXS, .labelXXSsemiBold
    ]

    public static let labelXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let labelL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let labelBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 16,
        lineHeight: 28,
        textStyle: .body
    )

    public static let labelS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 14,
        lineHeight: 20,
        textStyle: .body
    )

    public static let labelXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 12,
        lineHeight: 16,
        textStyle: .body
    )

    public static let labelXXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 10,
        lineHeight: 16,
        textStyle: .body
    )

    public static let labelXXSsemiBold = FontStyle(
        fontConvertible: ZZFonts.Poppins.semiBold,
        size: 10,
        lineHeight: 16,
        textStyle: .body
    )

    // MARK: - Link

    public static let allLinkFontStyles: [FontStyle] = [
        .linkXL, .linkL, .linkBase, .linkS, .linkXS
    ]

    public static let linkXL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 20,
        lineHeight: 32,
        textStyle: .body
    )

    public static let linkL = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 18,
        lineHeight: 28,
        textStyle: .body
    )

    public static let linkBase = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 16,
        lineHeight: 28,
        textStyle: .body
    )

    public static let linkS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 14,
        lineHeight: 20,
        textStyle: .body
    )

    public static let linkXS = FontStyle(
        fontConvertible: ZZFonts.Poppins.medium,
        size: 12,
        lineHeight: 16,
        textStyle: .body
    )
}
