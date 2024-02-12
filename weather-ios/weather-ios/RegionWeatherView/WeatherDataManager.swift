import UIKit

struct WeatherDataModel: Codable {
    var cityName: String
    var temperature: Double
    var weather: String
    var tempMinMax: String
    var backgroundImageName: String
    
    var backgroundImage: UIImage? {
        return UIImage(named: backgroundImageName)
    }
    
    init(cityName: String, temperature: Double, weather: String, tempMinMax: String, backgroundImageName: String) {
        self.cityName = cityName
        self.temperature = temperature
        self.weather = weather
        self.tempMinMax = tempMinMax
        self.backgroundImageName = backgroundImageName
    }
}



// UserDefaults
class WeatherDataManager {
    static let shared = WeatherDataManager()
    private let defaults = UserDefaults.standard
    private init() {}
    
    private func key(for location: String) -> String {
        return "WeatherData_\(location)"
    }
    
    func saveWeatherData(_ data: WeatherDataModel, for location: String) {
        let key = self.key(for: location)
        if let encodedData = try? JSONEncoder().encode(data) {
            defaults.set(encodedData, forKey: key)
        }
    }
    
    func updateWeatherData(_ data: WeatherDataModel, for location: String) {
        saveWeatherData(data, for: location)
    }
    
    func deleteWeatherData(for location: String) {
        let key = self.key(for: location)
        defaults.removeObject(forKey: key)
    }
}
