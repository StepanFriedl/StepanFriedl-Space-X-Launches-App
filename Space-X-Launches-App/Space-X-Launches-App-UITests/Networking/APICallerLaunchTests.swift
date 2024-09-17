//
//  APICallerLaunchTests.swift
//  Space-X-Launches-App-UITests
//
//  Created by Štěpán Friedl on 16.09.2024.
//

import XCTest
import SDWebImage
@testable import Space_X_Launches_App

final class APICallerParsingTests: XCTestCase {

    func testParseValidLaunchData() {
        let validJSON = """
        [
            {
                "fairings": null,
                "links": {
                    "patch": { "small": null, "large": "https://example.com/large.png" }
                },
                "rocket": null,
                "success": true,
                "name": "Falcon 1",
                "date_utc": "2006-03-24T22:30:00.000Z",
                "id": "5eb87cd9ffd86e000604b32a"
            }
        ]
        """.data(using: .utf8)!
        
        let result = APICaller.parseLaunchData(validJSON)
        
        switch result {
        case .success(let launches):
            XCTAssertEqual(launches.count, 1, "There should be one launch.")
            let launch = launches.first
            XCTAssertEqual(launch?.name, "Falcon 1", "Launch name should be 'Falcon 1'.")
            XCTAssertEqual(launch?.id, "5eb87cd9ffd86e000604b32a", "Launch ID should match.")
            XCTAssertNotNil(launch?.links?.patch?.large, "Large patch URL should not be nil.")
            XCTAssertNil(launch?.fairings, "Fairings should be nil.")
        case .failure(let error):
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseIncompleteLaunchData() {
        let incompleteJSON = """
        [
            {
                "name": "Falcon 1",
                "id": "5eb87cd9ffd86e000604b32a"
            }
        ]
        """.data(using: .utf8)!

        let result = APICaller.parseLaunchData(incompleteJSON)

        switch result {
        case .success(let launches):
            XCTAssertEqual(launches.count, 1, "There should be one launch parsed.")
            let launch = launches.first
            XCTAssertEqual(launch?.name, "Falcon 1", "Launch name should be 'Falcon 1'.")
            XCTAssertEqual(launch?.id, "5eb87cd9ffd86e000604b32a", "Launch ID should match.")
            
            XCTAssertNil(launch?.fairings, "Fairings should be nil since they are missing in the JSON.")
            XCTAssertNil(launch?.rocket, "Rocket should be nil since it is missing in the JSON.")
            XCTAssertNil(launch?.details, "Details should be nil since it is missing in the JSON.")
            
        case .failure(let error):
            XCTFail("Parsing failed with error: \(error), but it should have succeeded.")
        }
    }

    
    func testParseEmptyData() {
        let emptyJSON = Data()
        
        let result = APICaller.parseLaunchData(emptyJSON)
        
        switch result {
        case .success:
            XCTFail("Parsing should have failed, but it succeeded.")
        case .failure(let error):
            XCTAssertEqual(error, NetworkError.cannotParseData, "Expected cannotParseData error.")
        }
    }
}
