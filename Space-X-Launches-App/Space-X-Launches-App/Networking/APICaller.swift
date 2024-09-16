//
//  APICaller.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation


enum NetworkError: Error {
    case urlError
    case cannotParseData
}

public class APICaller {
    
    static func getPastLaunches(
        completionHandler: @escaping (_ result: Result<PastLaunches, NetworkError>) -> Void
    ) {
        let requestUrlString = NetworkConstant.shared.serverAddress +
        NetworkConstant.shared.pastLaunches
        guard let url = URL(string: requestUrlString) else {
            completionHandler(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.cannotParseData))
                return
            }
            
            let result = APICaller.parseLaunchData(data)
            completionHandler(result)
            
        }.resume()
    }
    
    static func parseLaunchData(_ data: Data) -> Result<PastLaunches, NetworkError> {
        do {
            let launches = try JSONDecoder().decode(PastLaunches.self, from: data)
            return .success(launches)
        } catch {
            return .failure(.cannotParseData)
        }
    }
}
