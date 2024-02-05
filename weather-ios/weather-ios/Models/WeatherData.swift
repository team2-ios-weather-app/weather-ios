//
//  WeatherData.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

import Foundation

struct WeatherData: Decodable {
    let request: Request
    let location: Location
    let current: Current
}

extension WeatherData {
    struct Request: Decodable {
        let type: String
        let query: String
        let language: String
        let unit: String
    }

    struct Location: Decodable {
        let name: String
        let country: String
        let region: String
        let lat: String
        let lon: String
        let timezoneId: String
        let localtime: String
        let localtimeEpoch: Int
        let utcOffset: String

        enum CodingKeys: String, CodingKey {
            case name, country, region, lat, lon, localtime, localtimeEpoch, utcOffset
            case timezoneId = "timezone_id"
        }
    }

    struct Current: Decodable {
        let observationTime: String
        let temperature: Int
        let weatherCode: Int
        let weatherIcons: [String]
        let weatherDescriptions: [String]
        let windSpeed: Int
        let windDegree: Int
        let windDir: String
        let pressure: Int
        let precip: Int
        let humidity: Int
        let cloudcover: Int
        let feelslike: Int
        let uvIndex: Int
        let visibility: Int

        enum CodingKeys: String, CodingKey {
            case temperature, pressure, precip, humidity, cloudcover, feelslike, visibility
            case observationTime = "observation_time"
            case weatherCode = "weather_code"
            case weatherIcons = "weather_icons"
            case weatherDescriptions = "weather_descriptions"
            case windSpeed = "wind_speed"
            case windDegree = "wind_degree"
            case windDir = "wind_dir"
            case uvIndex = "uv_index"
        }
    }
}
