//
//  UserSettings.swift
//  weather-ios
//
//  Created by JiHoon K on 2/15/24.
//

import Foundation

class UserSettings: Codable {
    static var shared = UserSettings.load()

    var selectedRegion: String // 선택된 지역 (현재 날씨 보여지는 지역)
    var weatherUnit: Units // 섭씨, 화씨
    var registeredRegions: [String] // 유저가 추가한 지역들

    private init(selectedRegion: String = "서울", weatherUnit: Units = .metric, registeredRegions: [String] = ["서울"]) {
        self.selectedRegion = selectedRegion
        self.weatherUnit = weatherUnit
        self.registeredRegions = registeredRegions
    }
    
    enum Units: String, Codable {
        case metric = "metric"
        case imperial = "imperial"
    }
}

extension UserSettings {
    static func load() -> UserSettings {
        if let data = UserDefaults.standard.data(forKey: "\(UserSettings.self)"),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            return settings
        }
        return UserSettings()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "\(UserSettings.self)")
        }
    }
}

extension UserSettings {
    func weatherUnitToggle() {
        weatherUnit = weatherUnit == .metric ? .imperial : .metric
    }
}
