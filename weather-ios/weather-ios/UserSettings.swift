//
//  UserSettings.swift
//  weather-ios
//
//  Created by JiHoon K on 2/15/24.
//

import Foundation

class UserSettings {
    static var shared = UserSettings()

    private init() { }
    
    var curntRegionName: String? = "서울"
    var weatherUnit: WeatherService.Units? = .metric
}

extension UserSettings {
    func weatherUnitToggle() {
        if UserSettings.shared.weatherUnit == .metric { UserSettings.shared.weatherUnit = .imperial }
        else if UserSettings.shared.weatherUnit == .imperial { UserSettings.shared.weatherUnit = .metric }
    }
}
