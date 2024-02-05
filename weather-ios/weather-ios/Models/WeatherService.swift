//
//  WeatherService.swift
//  weather-ios
//
//  Created by JiHoon K on 2/6/24.
//

import Foundation

struct WeatherService {
    private let apiKey = "44d36268ccbf0ac21e73ee116dfc87d9"
    
}

//MARK: - Requests
extension WeatherService {
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&lang=\("kr")"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherResponse)
            } catch {
                print(error)
            }
        }.resume()
    }
}

//MARK: - Helpers
extension WeatherService {
    
}
