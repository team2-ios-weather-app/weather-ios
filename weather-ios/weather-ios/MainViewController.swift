//
//  ViewController.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var weatherService = WeatherService()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupUI()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(temperatureLabel)
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupButtons()
    }
    
    private func setupButtons() {
        let currentLocationWeatherButton = UIButton(type: .system)
        currentLocationWeatherButton.setTitle("현재 위치 날씨", for: .normal)
        currentLocationWeatherButton.addTarget(self, action: #selector(updateCurrentWeather), for: .touchUpInside)
        
        let testLocationWeatherButton = UIButton(type: .system)
        testLocationWeatherButton.setTitle("테스트 위치 날씨", for: .normal)
        testLocationWeatherButton.addTarget(self, action: #selector(requestWeatherUpdate), for: .touchUpInside)
        
        view.addSubview(currentLocationWeatherButton)
        view.addSubview(testLocationWeatherButton)
        
        currentLocationWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        testLocationWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentLocationWeatherButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currentLocationWeatherButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            testLocationWeatherButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            testLocationWeatherButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func updateCurrentWeather() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc private func requestWeatherUpdate() {
        Task {
            let crntWeather = await weatherService.getCrntWeatherDataForCity("사하구")
            DispatchQueue.main.async {
                self.updateWeatherInfo(crntWeather)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("현재 위치: 위도 \(location.coordinate.latitude), 경도 \(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            
            weatherService.getCrntWeatherDataForCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { [weak self] weatherData in
                DispatchQueue.main.async {
                    self?.updateWeatherInfo(weatherData)
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 서비스 권한이 허용됨")
            locationManager.startUpdatingLocation()
        case .notDetermined, .restricted, .denied:
            print("위치 서비스 권한이 없거나 제한됨")
        @unknown default:
            print("알 수 없는 새로운 권한 상태")
        }
    }
    
    func updateWeatherInfo(_ weatherData: CrntWeatherData?) {
        guard let weatherData = weatherData else {
            temperatureLabel.text = "날씨 정보를 가져올 수 없습니다."
            return
        }
        
        let temperature = weatherData.main?.temp ?? 0
        let weatherStatus = weatherData.weather?.first?.description ?? "정보 없음"
        let cityName = weatherData.name ?? "알 수 없는 도시"
        
        temperatureLabel.text = "도시: \(cityName)\n온도: \(temperature)°C\n상태: \(weatherStatus)"
    }
}


