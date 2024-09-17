//
//  PastLaunches.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

// MARK: - Launch
struct Launch: Codable {
    let fairings: Fairings?
    let links: Links?
    let staticFireDateUTC: String?
    let staticFireDateUnix: Int?
    let net: Bool?
    let window: Int?
    let rocket: String?
    let success: Bool?
    let failures: [Failure]?
    let details: String?
    let crew: [Crew]?
    let ships: [String]?
    let capsules: [String]?
    let payloads: [String]?
    let launchpad: String?
    let flightNumber: Int?
    let name: String?
    let dateUTC: String?
    let dateUnix: Int?
    let dateLocal: String?
    let datePrecision: String?
    let upcoming: Bool?
    let cores: [Core]?
    let autoUpdate: Bool?
    let tbd: Bool?
    let launchLibraryID: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case fairings, links
        case staticFireDateUTC = "static_fire_date_utc"
        case staticFireDateUnix = "static_fire_date_unix"
        case net, window, rocket, success, failures, details, crew, ships, capsules, payloads, launchpad
        case flightNumber = "flight_number"
        case name
        case dateUTC = "date_utc"
        case dateUnix = "date_unix"
        case dateLocal = "date_local"
        case datePrecision = "date_precision"
        case upcoming, cores
        case autoUpdate = "auto_update"
        case tbd
        case launchLibraryID = "launch_library_id"
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fairings = try container.decodeIfPresent(Fairings.self, forKey: .fairings)
        links = try container.decodeIfPresent(Links.self, forKey: .links)
        staticFireDateUTC = try container.decodeIfPresent(String.self, forKey: .staticFireDateUTC)
        staticFireDateUnix = try container.decodeIfPresent(Int.self, forKey: .staticFireDateUnix)
        net = try container.decodeIfPresent(Bool.self, forKey: .net)
        window = try container.decodeIfPresent(Int.self, forKey: .window)
        rocket = try container.decodeIfPresent(String.self, forKey: .rocket)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        failures = try container.decodeIfPresent([Failure].self, forKey: .failures)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        crew = try container.decodeIfPresent([Crew].self, forKey: .crew)
        ships = try container.decodeIfPresent([String].self, forKey: .ships)
        capsules = try container.decodeIfPresent([String].self, forKey: .capsules)
        payloads = try container.decodeIfPresent([String].self, forKey: .payloads)
        launchpad = try container.decodeIfPresent(String.self, forKey: .launchpad)
        flightNumber = try container.decodeIfPresent(Int.self, forKey: .flightNumber)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        dateUTC = try container.decodeIfPresent(String.self, forKey: .dateUTC)
        dateUnix = try container.decodeIfPresent(Int.self, forKey: .dateUnix)
        dateLocal = try container.decodeIfPresent(String.self, forKey: .dateLocal)
        datePrecision = try container.decodeIfPresent(String.self, forKey: .datePrecision)
        upcoming = try container.decodeIfPresent(Bool.self, forKey: .upcoming)
        cores = try container.decodeIfPresent([Core].self, forKey: .cores)
        autoUpdate = try container.decodeIfPresent(Bool.self, forKey: .autoUpdate)
        tbd = try container.decodeIfPresent(Bool.self, forKey: .tbd)
        launchLibraryID = try container.decodeIfPresent(String.self, forKey: .launchLibraryID)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}

// MARK: - Core
struct Core: Codable {
    let core: String?
    let flight: Int?
    let gridfins: Bool?
    let legs: Bool?
    let reused: Bool?
    let landingAttempt: Bool?
    let landingSuccess: Bool?
    let landingType: String?
    let landpad: String?

    enum CodingKeys: String, CodingKey {
        case core, flight, gridfins, legs, reused
        case landingAttempt = "landing_attempt"
        case landingSuccess = "landing_success"
        case landingType = "landing_type"
        case landpad
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        core = try container.decodeIfPresent(String.self, forKey: .core)
        flight = try container.decodeIfPresent(Int.self, forKey: .flight)
        gridfins = try container.decodeIfPresent(Bool.self, forKey: .gridfins)
        legs = try container.decodeIfPresent(Bool.self, forKey: .legs)
        reused = try container.decodeIfPresent(Bool.self, forKey: .reused)
        landingAttempt = try container.decodeIfPresent(Bool.self, forKey: .landingAttempt)
        landingSuccess = try container.decodeIfPresent(Bool.self, forKey: .landingSuccess)
        landingType = try container.decodeIfPresent(String.self, forKey: .landingType)
        landpad = try container.decodeIfPresent(String.self, forKey: .landpad)
    }
}

// MARK: - Crew
struct Crew: Codable {
    let crew: String?
    let role: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        crew = try container.decodeIfPresent(String.self, forKey: .crew)
        role = try container.decodeIfPresent(String.self, forKey: .role)
    }
}

// MARK: - Failure
struct Failure: Codable, Hashable {
    let time: Int?
    let altitude: Int?
    let reason: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decodeIfPresent(Int.self, forKey: .time)
        altitude = try container.decodeIfPresent(Int.self, forKey: .altitude)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }
    
    init(time: Int?, altitude: Int?, reason: String?) {
        self.time = time
        self.altitude = altitude
        self.reason = reason
    }
}

// MARK: - Fairings
struct Fairings: Codable {
    let reused: Bool?
    let recoveryAttempt: Bool?
    let recovered: Bool?
    let ships: [String]?

    enum CodingKeys: String, CodingKey {
        case reused
        case recoveryAttempt = "recovery_attempt"
        case recovered, ships
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reused = try container.decodeIfPresent(Bool.self, forKey: .reused)
        recoveryAttempt = try container.decodeIfPresent(Bool.self, forKey: .recoveryAttempt)
        recovered = try container.decodeIfPresent(Bool.self, forKey: .recovered)
        ships = try container.decodeIfPresent([String].self, forKey: .ships)
    }
}

// MARK: - Links
struct Links: Codable {
    let patch: Patch?
    let reddit: Reddit?
    let flickr: Flickr?
    let presskit: String?
    let webcast: String?
    let youtubeID: String?
    let article: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch, reddit, flickr, presskit, webcast
        case youtubeID = "youtube_id"
        case article, wikipedia
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        patch = try container.decodeIfPresent(Patch.self, forKey: .patch)
        reddit = try container.decodeIfPresent(Reddit.self, forKey: .reddit)
        flickr = try container.decodeIfPresent(Flickr.self, forKey: .flickr)
        presskit = try container.decodeIfPresent(String.self, forKey: .presskit)
        webcast = try container.decodeIfPresent(String.self, forKey: .webcast)
        youtubeID = try container.decodeIfPresent(String.self, forKey: .youtubeID)
        article = try container.decodeIfPresent(String.self, forKey: .article)
        wikipedia = try container.decodeIfPresent(String.self, forKey: .wikipedia)
    }
}

// MARK: - Flickr
struct Flickr: Codable {
    let small: [String]?
    let original: [String]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent([String].self, forKey: .small)
        original = try container.decodeIfPresent([String].self, forKey: .original)
    }
}

// MARK: - Patch
struct Patch: Codable {
    let small: String?
    let large: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small)
        large = try container.decodeIfPresent(String.self, forKey: .large)
    }
}

// MARK: - Reddit
struct Reddit: Codable {
    let campaign: String?
    let launch: String?
    let media: String?
    let recovery: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        campaign = try container.decodeIfPresent(String.self, forKey: .campaign)
        launch = try container.decodeIfPresent(String.self, forKey: .launch)
        media = try container.decodeIfPresent(String.self, forKey: .media)
        recovery = try container.decodeIfPresent(String.self, forKey: .recovery)
    }
}

typealias PastLaunches = [Launch]
