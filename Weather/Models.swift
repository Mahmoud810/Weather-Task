//
//  Models.swift
//  Weather
//
//  Created by Mahmoud on 17/07/2025.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastEntry]
}

struct ForecastEntry: Codable {
    let dt_txt: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

import Foundation

struct City: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}


struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}
