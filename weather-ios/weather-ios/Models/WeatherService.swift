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
    func getCrntWeatherData(lat: Double, lon: Double, completion: @escaping (CrntWeatherData?) -> Void) {
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

//MARK: - Helpers
extension WeatherService {
    static func testGetCrntWeatherData() -> CrntWeatherData { // 사용 예시: WeatherService.testGetCrntWeatherData()
        return CrntWeatherData(coord: .init(lon: 35.2100, lat: 129.0689),
                           weather: [.init(id: 804,
                                           main: "Clouds",
                                           description: "온흐림",
                                           icon: "04n")],
                           main: .init(temp: 276.57,
                                       feelsLike: 273.43,
                                       tempMin: 276.57,
                                       tempMax: 276.57,
                                       pressure: 1025,
                                       humidity: 85,
                                       seaLevel: 1025,
                                       grndLevel: 1022),
                           visibility: 10000,
                           wind: .init(speed: 3.45,
                                       deg: 19,
                                       gust: 5.19),
                           clouds: .init(all: 100),
                           rain: nil,
                           snow: nil,
                           dt: 1707167722,
                           sys: .init(type: nil,
                                      id: nil,
                                      country: "KR",
                                      sunrise: 1707171588,
                                      sunset: 1707209740),
                           timezone: 32400,
                           id: 1838519,
                           name: "Busan",
                           cod: 200)
    }
}
