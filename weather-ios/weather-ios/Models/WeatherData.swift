//
//  WeatherData.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

struct WeatherData: Decodable {
    let coord: Coordinates?
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    
    struct Coordinates: Decodable {
        let lon: Double?
        let lat: Double?
    }
    
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Main: Decodable {
        let temp: Double?
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int?
        let humidity: Int?
        
        private enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
    
    struct Clouds: Decodable {
        let all: Int?
    }
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
}
