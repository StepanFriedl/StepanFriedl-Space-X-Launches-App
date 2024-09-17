//
//  APICaller.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation
import RequestsQueue

// MARK: - NetworkError Enum
enum NetworkError: Error {
    case urlError
    case cannotParseData
}

// MARK: - APICaller Class
public class APICaller {
    
    // MARK: - Fetch Past Launches
    static func fetchData<T: Decodable>(
        from urlString: String,
        completionHandler: @escaping (_ result: Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        NetworkMonitor.shared.requestsQueueManager.addRequest(requestID: "getPastLaunches") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    completionHandler(.failure(.cannotParseData))
                    return
                }
                
                let result: Result<T, NetworkError> = APICaller.parseLaunchData(data)
                completionHandler(result)
                
            }.resume()
        }
    }
    
    // MARK: - Data Parsing
    static func parseLaunchData<T: Decodable>(_ data: Data) -> Result<T, NetworkError> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.cannotParseData)
        }
    }
    
}
