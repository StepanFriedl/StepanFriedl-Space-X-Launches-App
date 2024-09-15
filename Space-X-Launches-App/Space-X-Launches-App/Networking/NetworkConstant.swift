//
//  NetworkConstant.swift
//  Space-X-Launches-App
//
//  Created by Štěpán Friedl on 15.09.2024.
//

import Foundation

class NetworkConstant {
    public static var shared = NetworkConstant()
    
    private init() {}
    
    let serverAddress = "https://api.spacexdata.com/"
    
    let pastLaunches = "v5/launches/past"
}
