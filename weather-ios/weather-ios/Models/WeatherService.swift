//
//  WeatherService.swift
//  weather-ios
//
//  Created by JiHoon K on 2/6/24.
//

import Foundation

class WeatherService {
    private let apiKey = "44d36268ccbf0ac21e73ee116dfc87d9"
    
}

//MARK: - Requests
extension WeatherService {
    
    /// 도시 이름 넣으면 현재 날씨 데이터 반환
    func getCrntWeatherDataForCity(_ cityName: String) async -> CrntWeatherData? {
        guard let coordi = await WeatherService().getCoordinateForCity(cityName) else { return nil }
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordi.lat)&lon=\(coordi.lon)&appid=\(apiKey)&lang=kr&units=metric"
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode(CrntWeatherData.self, from: data)
            return weatherResponse
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 도시 이름 넣으면 좌표 데이터 반환
    func getCoordinateForCity(_ cityName: String) async -> Coordinate? {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=1&appid=\(apiKey)"
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
    
    /// 위경도로 날씨 데이터 반환
    func getCrntWeatherDataForCoordinates(lat: Double, lon: Double, completion: @escaping (CrntWeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&lang=\("kr")"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weatherResponse = try JSONDecoder().decode(CrntWeatherData.self, from: data)
                completion(weatherResponse)
            } catch {
                print(error)
            }
        }.resume()
    }
}
