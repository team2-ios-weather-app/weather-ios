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
    func getCrntWeatherData(_ cityName: String) async -> CrntWeatherData? {
        guard let coordi = await WeatherService().getCoordinate(cityName) else { return nil }
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
    func getCoordinate(_ cityName: String) async -> Coordinate? {
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
}

//MARK: - Helpers
extension WeatherService {
    static func testGetCrntWeatherData() -> CrntWeatherData { // 사용 예시: WeatherService.testGetCrntWeatherData()
        return CrntWeatherData(coord: .init(lat: 129.0689, lon: 35.2100),
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
