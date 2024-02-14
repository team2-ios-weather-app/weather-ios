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
    func getCrntWeatherData(regionName: String? = nil, coordinate: Coordinate? = nil, unit: UserSettings.Units) async -> CrntWeatherData? {
        var coordinate = coordinate
        if let regionName = regionName { coordinate = await getCoordinateFor(regionName) }
            
        if let coordinate = coordinate {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.lat)&lon=\(coordinate.lon)&appid=\(Secrets.openWeatherMapAPIKey)&lang=kr&units=\(unit.rawValue)"
            guard let url = URL(string: urlString) else { return nil }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                var weatherResponse = try JSONDecoder().decode(CrntWeatherData.self, from: data)
                weatherResponse.coord = coordinate
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
    func getCoordinateFor(_ regionName: String) async -> Coordinate? {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(regionName)&limit=1&appid=\(Secrets.openWeatherMapAPIKey)"
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
    static func testGetCrntWeatherData() async -> CrntWeatherData? {
        do {
            try await Task.sleep(nanoseconds: 900000000)
        } catch {
            print(error.localizedDescription)
        }
        
        return CrntWeatherData(coord: .init(lat: 35.1811, lon: 129.0928, localNames: .init(en: nil, ko: "연산동")),
                               weather: [.init(id: 803,
                                               main: "Clouds",
                                               description: "튼구름",
                                               icon: "04n")],
                               main: .init(temp: 5.4,
                                           feelsLike: 4.35,
                                           tempMin: 5.4,
                                           tempMax: 5.4,
                                           pressure: 1026,
                                           humidity: 87,
                                           seaLevel: 1025,
                                           grndLevel: 1022),
                               visibility: 9000,
                               wind: .init(speed: 1.54,
                                           deg: 150,
                                           gust: 5.19),
                               clouds: .init(all: 75),
                               rain: nil,
                               snow: nil,
                               dt: 1707849634,
                               sys: .init(type: nil,
                                          id: nil,
                                          country: "KR",
                                          sunrise: 1707862330,
                                          sunset: 1707901423),
                               timezone: 32400,
                               id: 1838519,
                               name: "Busan",
                               cod: 200)
    }
}
