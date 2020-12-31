//
//  WeatherTarget.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/31/20.
//

import Moya
import Foundation

enum WeatherTarget {
    case currentWeather
}

extension WeatherTarget: TargetType {
    var baseURL: URL {
        return URL(string: NetworkManager.weatherBasePath)!
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .currentWeather:
            return .requestParameters(parameters: ["q": "Krasnoyarsk",
                                                   "appid": AppConstants.apiKey,
                                                   "units": "metric"],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
