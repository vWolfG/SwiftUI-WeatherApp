//
//  WeatherModel.swift
//  SwiftUI-Weather
//
//  Created by Veronika Goreva on 12/31/20.
//

import Foundation

struct CurrentWeather: Codable {
    let weather: [Weather]
    let main: MainWeatherInfo
    let coord: Coordinate
    let name: String
}

struct Coordinate: Codable {
    let lat: Float
    let lon: Float
}

struct MainWeatherInfo: Codable {
    let temp: Float
    let feelsLike: Float
    let tempMin: Float
    let tempMax: Float
    let pressure: Int
    let humidity: Int
}

struct Wind {
    let speed: Float
    let deg: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
