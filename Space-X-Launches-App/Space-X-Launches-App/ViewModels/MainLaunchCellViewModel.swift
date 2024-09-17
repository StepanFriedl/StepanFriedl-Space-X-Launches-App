//
//  MainLaunchCellViewModel.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

class MainLaunchCellViewModel {
    
    // MARK: - Properties
    var id: String
    var name: String
    var date: Date?
    var imageUrl: URL?
    var isSuccess: Bool?
    
    // MARK: - Initializer
    init(launch: Launch) {
        self.id = launch.id ?? ""
        self.name = launch.name ?? ""
        self.isSuccess = launch.success
        self.date = launch.dateUTC?.toDate()
        self.imageUrl = launch.links?.patch?.small?.toUrl()
    }
        
    // MARK: - Date Formatting
    func dateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. MM. yyyy HH:mm"
        guard let date = self.date else {
            return ""
        }
        return dateFormatter.string(from: date)
    }
    
}
