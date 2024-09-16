//
//  Extensions.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import UIKit

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
    
}

extension URL {
    
    func openInBrowser() {
        UIApplication.shared.open(self, options: [:], completionHandler: nil)
    }
    
}
