//
//  WeatherService.swift
//  weather-ios
//
//  Created by JiHoon K on 2/6/24.
//

import Foundation

class WeatherService {
    
}

//MARK: - Requests
extension WeatherService {
    /// 도시 이름 또는 좌표 둘 중 하나만 넣으면 현재 날씨 데이터 반환
    func getCrntWeatherData(cityName: String? = nil, coordinate: Coordinate? = nil) async -> CrntWeatherData? {
        var coordinate = coordinate
        if let cityName = cityName { coordinate = await getCoordinateFor(cityName) }
            
        if let coordinate = coordinate {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.lat)&lon=\(coordinate.lon)&appid=\(Secrets.openWeatherMapAPIKey)&lang=kr&units=metric"
            guard let url = URL(string: urlString) else { return nil }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let weatherResponse = try JSONDecoder().decode(CrntWeatherData.self, from: data)
                return weatherResponse
            } catch {
                print(error)
                return nil
            }
        } else {
            print("coordinate nil")
            return nil
        }
    }
    
    /// 도시 이름 넣으면 좌표 데이터 반환
    func getCoordinateFor(_ cityName: String) async -> Coordinate? {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=1&appid=\(Secrets.openWeatherMapAPIKey)"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode([Coordinate].self, from: data)
            return weatherResponse.first // Assuming you're interested in the first result
        } catch {
            print(error)
            return nil
        }
    }
}
