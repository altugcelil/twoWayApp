//
//  Constants.swift
//  twoWayApp
//
//  Created by Berkut Teknoloji on 28.07.2025.
//

import UIKit

// MARK: - Design System
struct AppColors {
    
    // MARK: - Gece Vardiyası Teması
    
    // Ana Renkler
    static let background = UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1.0)      // #141420
    static let surface = UIColor(red: 0.12, green: 0.13, blue: 0.18, alpha: 1.0)        // #1F212D  
    static let cardBackground = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0) // #F2F2F7
    
    // Text Renkleri  
    static let primaryText = UIColor(red: 0.05, green: 0.05, blue: 0.07, alpha: 1.0)    // #0C0C12
    static let secondaryText = UIColor(red: 0.45, green: 0.45, blue: 0.50, alpha: 1.0)  // #73737F
    static let headerText = UIColor(red: 0.92, green: 0.92, blue: 0.96, alpha: 1.0)     // #EBEEF5
    
    // Accent & Button
    static let primary = UIColor(red: 0.0, green: 0.48, blue: 0.65, alpha: 1.0)         // #007BA6
    static let accent = primary  // Alias for modern naming
    static let buttonText = UIColor.white
    
    // Text Colors (Modern naming)
    static let textPrimary = primaryText      // Modern alias
    static let textSecondary = secondaryText  // Modern alias
    
    // System Colors (iOS adaptive)
    static let danger = UIColor.systemRed
    static let success = UIColor.systemGreen  
    static let warning = UIColor.systemOrange
}

struct AppLayout {
    
    // MARK: - Adaptive Spacing System
    
    // Standart spacing (16px base)
    static let spacing: CGFloat = 16
    static let spacingHalf: CGFloat = 8      // spacing / 2
    static let spacingDouble: CGFloat = 32   // spacing * 2
    
    // Adaptive margins (Safe Area'ya uyumlu)
    static var horizontalMargin: CGFloat {
        return spacing // iPhone'da 16, iPad'de auto scaling
    }
    
    static var verticalMargin: CGFloat {
        return spacing
    }
    
    // Corner Radius (adaptive)
    static let cornerRadius: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    
    // Button Height (Dynamic Type'a uyumlu)
    static let buttonHeight: CGFloat = 52
    
    // Card sizing (ekran boyutuna göre adaptive)
    static func cardWidth(for view: UIView) -> CGFloat {
        let screenWidth = view.bounds.width
        if screenWidth > 414 { // iPad veya Plus phones
            return min(400, screenWidth - (horizontalMargin * 2))
        }
        return screenWidth - (horizontalMargin * 2)
    }
    
    static func cardHeight(for contentHeight: CGFloat) -> CGFloat {
        return contentHeight + (spacing * 4) // İçerik + padding
    }
}

struct AppFonts {
    
    // MARK: - Dynamic Type Adaptive Fonts
    
    // Başlıklar (Dynamic Type uyumlu)
    static let titleLarge = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 28, weight: .bold))
    static let titleMedium = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 22, weight: .semibold))
    static let titleSmall = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    
    // Body Text
    static let body = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16, weight: .regular))
    static let caption = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14, weight: .medium))
    
    // Button Text  
    static let button = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 17, weight: .semibold))
}

// MARK: - App Content
struct AppContent {
    
    // MARK: - Gece Vardiyası Strings
    
    static let welcomeTitle = "İki Yol"
    static let storyCardTitle = "Bugünün Hikayesi"
    static let mainStoryTitle = "Gece Vardiyası"
    static let startButtonTitle = "Başla"
}

// MARK: - Adaptive Extensions
extension UIView {
    
    /// Safe area'ya uyumlu margin hesaplaması
    var adaptiveHorizontalMargin: CGFloat {
        return max(AppLayout.horizontalMargin, safeAreaInsets.left + AppLayout.spacing)
    }
    
    var adaptiveVerticalMargin: CGFloat {
        return max(AppLayout.verticalMargin, safeAreaInsets.top + AppLayout.spacing)
    }
} 
