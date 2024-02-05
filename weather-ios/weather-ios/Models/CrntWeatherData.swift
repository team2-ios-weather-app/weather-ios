//
//  CrntWeatherData.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

/// Current weather data
struct CrntWeatherData: Decodable {
    let coord: Coordinates?
    let weather: [Weather]?
    let main: Main?
    let visibility: Int? // 가시성, 미터. 가시성의 최대 값은 10km입니다
    let wind: Wind?
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let dt: Int? // 데이터 계산 시간, unix, UTC
    let sys: Sys?
    let timezone: Int?
    let id: Int? //  City ID. Please note that built-in geocoder functionality has been deprecated. Learn more
    let name: String? // 도시 이름
    let cod: Int?
    
    struct Coordinates: Decodable {
        let lon: Double? // 경도
        let lat: Double? // 위도
    }
    
    struct Weather: Decodable {
        let id: Int? // 날씨 상태 ID (참고: https://openweathermap.org/weather-conditions)
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Main: Decodable {
        let temp: Double? // 온도 (단위 기본값: 켈빈, 미터법: 섭씨, 영국식: 화씨)
        let feelsLike: Double?  // 체감 온도
        let tempMin: Double? // 현재 최저기온
        let tempMax: Double? // 현재 최고기온
        let pressure: Int? // 기압
        let humidity: Int? // 습도, %
        let seaLevel: Int? // 해수면의 대기압, hPa
        let grndLevel: Int? // 지면의 대기압, hPa
        
        private enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double? // 바람 속도. 단위 기본값: 미터/초, 미터법: 미터/초, 영국식: 마일/시간
        let deg: Int? // 풍향, 각도(기상)
        let gust: Double? // 돌풍. 단위 기본값: 미터/초, 미터법: 미터/초, 영국식: 마일/시간
    }
    
    struct Clouds: Decodable {
        let all: Int? // 흐림, %
    }
    
    struct Rain: Decodable {
        let h1: Double? // (가능한 경우) 지난 1시간 동안의 강우량(mm). 이 매개변수에는 측정 단위로 mm만 사용할 수 있습니다.
        let h3: Double? // (가능한 경우) 지난 3시간 동안
        
        private enum CodingKeys: String, CodingKey {
            case h1 = "1h"
            case h3 = "3h"
        }
    }
    
    struct Snow: Decodable {
        let h1: Double? // (가능한 경우) 지난 1시간 동안의 적설량, mm. 이 매개변수에는 측정 단위로 mm만 사용할 수 있습니다.
        let h3: Double? // (가능한 경우) 지난 3시간 동안
        
        private enum CodingKeys: String, CodingKey {
            case h1 = "1h"
            case h3 = "3h"
        }
    }
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let country: String? // 국가 코드(GB, JP 등)
        let sunrise: Int? // 일출 시간, 유닉스, UTC
        let sunset: Int? // 일몰 시간, 유닉스, UTC
    }
}
