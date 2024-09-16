//
//  MainLaunchCellViewModel.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

class MainLaunchCellViewModel {
    
    var id: String
    var name: String
    var date: Date?
    var imageUrl: URL?
    var isSuccess: Bool?
    
    init(launch: Launch) {
        self.id = launch.id ?? ""
        self.name = launch.name ?? ""
        self.isSuccess = launch.success
        self.date = makeDateFromUTCString(launch.dateUTC)
        self.imageUrl = makeImageUrl(launch)
        
    }
    
    private func makeImageUrl(_ launch: Launch) -> URL? {
        guard let imagePath = launch.links?.patch?.small else {
            return nil
        }
        return URL(string: imagePath)
    }
    
    private func makeDateFromUTCString(_ utcString: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let utcString = utcString, let date = dateFormatter.date(from: utcString) else {
            return nil
        }
        return date
    }
    
    func dateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:yy HH:mm"
        guard let date = self.date else {
            return ""
        }
        return dateFormatter.string(from: date)
    }
}
