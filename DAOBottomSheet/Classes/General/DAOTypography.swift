//
//  DAOTypography.swift
//  DAOBottomSheet
//
//  Created by DAO on 2021/11/29.
//

import UIKit

public enum DAOTypography {
    case h4
    case h5
    case h6
    case subtitleLg
    case subtitleMd
    case bodyLg
    case bodyMd
    case bodyMdLink
    case bodySm
    
    public var attributes: [NSAttributedString.Key: Any] {
        switch self {
        case .h4:
            let font = UIFont.systemFont(ofSize: 24, weight: .bold)
            let lineHeight = 30.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .h5:
            let font = UIFont.systemFont(ofSize: 22, weight: .bold)
            let lineHeight = 28.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .h6:
            let font = UIFont.systemFont(ofSize: 18, weight: .bold)
            let lineHeight = 26.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .subtitleLg:
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            let lineHeight = 24.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .subtitleMd:
            let font = UIFont.systemFont(ofSize: 14, weight: .bold)
            let lineHeight = 20.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .bodyLg:
            let font = UIFont.systemFont(ofSize: 16, weight: .regular)
            let lineHeight = 24.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .bodyMd:
            let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            let lineHeight = 20.0
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
            
        case .bodyMdLink:
            let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            let lineHeight = 20.0
            var attributes = getTypographyAttributes(with: font, lineHeight: lineHeight)
            attributes[.underlineStyle] = NSUnderlineStyle.styleSingle.rawValue
            return attributes
            
        case .bodySm:
            let font = UIFont.systemFont(ofSize: 12, weight: .regular)
            let lineHeight = font.lineHeight
            return getTypographyAttributes(with: font, lineHeight: lineHeight)
        }
    }
}

extension DAOTypography {
    func getTypographyAttributes(with font: UIFont, lineHeight: CGFloat) -> [NSAttributedString.Key: Any] {
        return [
            .font: font,
            .paragraphStyle: getParagraphStyle(with: lineHeight),
            .baselineOffset: getBaselineOffset(with: lineHeight, fontLineHeight: font.lineHeight)
        ]
    }
    
    func getParagraphStyle(with lineHeight: CGFloat) -> NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        return style
    }
    
    /// Correct text vertical alignment
    /// - Parameters:
    ///   - lineHeight: Text line height that designer wanted
    ///   - fontLineHeight: The default line height with font, you can get this value by font.lineHeight
    func getBaselineOffset(with lineHeight: CGFloat, fontLineHeight: CGFloat) -> CGFloat {
        return (lineHeight - fontLineHeight) / 4
    }
}

public enum Color {
    case black
    case green
    
    var value: UIColor {
        switch self {
        case .black:
            return UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
            
        case .green:
            return UIColor(red: 0.075, green: 0.639, blue: 0.714, alpha: 1)
        }
    }
}

public extension NSMutableAttributedString {
    /// Add typography style to attributed string
    /// - Parameter typography: ``DAOTypography``
    /// - Returns: NSMutableAttributedString with typography style
    func typography(_ typography: DAOTypography) -> NSMutableAttributedString {
        self.addAttributes(typography.attributes, range: NSRange(location: 0, length: self.length))
        return self
    }
    
    /// Add typographyWithColor style to attributed string
    /// - Parameter typography: ``DAOTypography``, color: ``UIColor``
    /// - Returns: NSMutableAttributedString with typography and color style
    func typographyWithColor(_ typography: DAOTypography, color: UIColor) -> NSMutableAttributedString {
        self.addAttributes(typography.attributes, range: NSRange(location: 0, length: self.length))
        self.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: self.length))
        return self
    }
}
