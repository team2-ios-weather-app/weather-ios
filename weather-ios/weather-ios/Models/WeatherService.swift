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
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.lat)&lon=\(coordinate.lon)&appid=\(Secrets.openWeatherMapAPIKey)&units=\(unit.rawValue)"
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
    
    func getTheDescriptionKorVer(_ engVer: String) -> String {
        switch engVer {
        case "clear sky": "맑은 하늘"
        case "few clouds": "구름 조금"
        case "scattered clouds": "조각 구름"
        case "broken clouds": "부서진 구름"
        case "shower rain": "소나기"
        case "rain": "비"
        case "thunderstorm": "천둥번개"
        case "snow": "눈"
        case "mist": "안개"
        case "thunderstorm with light rain": "약한 비를 동반한 천둥번개"
        case "thunderstorm with rain": "비를 동반한 천둥번개"
        case "thunderstorm with heavy rain": "강한 비를 동반한 천둥번개"
        case "light thunderstorm": "약한 천둥번개"
        case "heavy thunderstorm": "강한 천둥번개"
        case "ragged thunderstorm": "불규칙적인 천둥번개"
        case "thunderstorm with light drizzle": "약한 이슬비를 동반한 천둥번개"
        case "thunderstorm with drizzle": "이슬비를 동반한 천둥번개"
        case "thunderstorm with heavy drizzle": "강한 이슬비를 동반한 천둥번개"
        case "light intensity drizzle": "약한 이슬비"
        case "drizzle": "이슬비"
        case "heavy intensity drizzle": "강한 이슬비"
        case "light intensity drizzle rain": "약한 이슬비 비"
        case "drizzle rain": "이슬비 비"
        case "heavy intensity drizzle rain": "강한 이슬비 비"
        case "shower rain and drizzle": "소나기와 이슬비"
        case "heavy shower rain and drizzle": "강한 소나기와 이슬비"
        case "shower drizzle": "소나기 이슬비"
        case "light rain": "약한 비"
        case "moderate rain": "중간 비"
        case "heavy intensity rain": "강한 비"
        case "very heavy rain": "매우 강한 비"
        case "extreme rain": "극심한 비"
        case "freezing rain": "얼어붙는 비"
        case "light intensity shower rain": "약한 소나기 비"
        case "heavy intensity shower rain": "강한 소나기 비"
        case "ragged shower rain": "불규칙적인 소나기 비"
        case "light snow": "약한 눈"
        case "heavy snow": "강한 눈"
        case "sleet": "진눈깨비"
        case "light shower sleet": "약한 진눈깨비 소나기"
        case "shower sleet": "진눈깨비 소나기"
        case "light rain and snow": "약한 비와 눈"
        case "rain and snow": "비와 눈"
        case "light shower snow": "약한 눈 소나기"
        case "shower snow": "눈 소나기"
        case "heavy shower snow": "강한 눈 소나기"
        case "smoke": "연기"
        case "haze": "안개"
        case "sand/dust whirls": "모래/먼지 회오리"
        case "fog": "안개"
        case "sand": "모래"
        case "dust": "먼지"
        case "volcanic ash": "화산재"
        case "squalls": "돌풍"
        case "tornado": "토네이도"
        default: ""
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
                                               description: "few clouds",
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
