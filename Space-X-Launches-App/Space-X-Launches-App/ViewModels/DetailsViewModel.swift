//
//  DetailsViewModel.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 16.09.2024.
//

import SwiftUI

class DetailsViewModel: ObservableObject {
    
    var id: String
    var imageURL: URL?
    var name: String
    var launched: Date?
    var flightNumber: Int?
    var success: Bool?
    var failures: [Failure]?
    var youtubeLink: URL?
    var articleLink: URL?
    var wikiLink: URL?
    
    init(launch: Launch) {
        self.id = launch.id ?? "unknown".localized()
        self.name = launch.name ?? "unknown".localized()
        self.flightNumber = launch.flightNumber
        self.success = launch.success
        self.failures = launch.failures
        self.youtubeLink = launch.links?.webcast?.toUrl()
        self.articleLink = launch.links?.article?.toUrl()
        self.wikiLink = launch.links?.article?.toUrl()
        self.launched = launch.dateUTC?.toDate()
        self.imageURL = launch.links?.patch?.large?.toUrl()
    }
    
    init() {
        let failure = Failure(time: 301, altitude: 289, reason: "harmonic oscillation leading to premature engine shutdown")
        
        self.id = "123"
        self.imageURL = URL(string: "https://images2.imgbox.com/5b/02/QcxHUb5V_o.png")
        self.name = "FalconSat"
        self.flightNumber = 1
        self.launched = ISO8601DateFormatter().date(from: "2006-03-24T22:30:00.000Z")
        self.success = false
        self.failures = [failure]
        self.youtubeLink = URL(string: "https://www.youtube.com/watch?v=0a_00nJ_Y88")
        self.articleLink = URL(string: "https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html")
        self.wikiLink = URL(string: "https://en.wikipedia.org/wiki/DemoSat")
    }
    
    func isAnyLinkPresent() -> Bool {
        youtubeLink != nil || articleLink != nil || wikiLink != nil
    }
    
}
