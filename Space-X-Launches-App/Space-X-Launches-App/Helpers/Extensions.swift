//
//  Extensions.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit

// MARK: - UIView Extensions
extension UIView {
    
    func round(_ radius: CGFloat = 8) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addBorder(color: UIColor, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}

// MARK: - String Extensions
extension String {
    
    func toDate(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone = .current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
    
    func toUrl() -> URL? {
        return URL(string: self)
    }
    
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
    
}

// MARK: - URL Extensions
extension URL {
    
    func openInBrowser() {
        UIApplication.shared.open(self, options: [:], completionHandler: nil)
    }
    
}

// MARK: - UIImage Extensions
extension UIImage {
    
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}

// MARK: - UIButton Extensions
extension UIButton {
    
    func animateClick(duration: TimeInterval = 0.1, toAlpha alpha: CGFloat = 0.1, completionAlpha: CGFloat = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }) { _ in
            UIView.animate(withDuration: duration) {
                self.alpha = completionAlpha
            }
        }
    }
    
}
