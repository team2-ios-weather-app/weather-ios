//
//  ViewController.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
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
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLocationManager()
//        setupUI()
        
        setUpTableView()
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

//MARK: - Views
extension MainViewController {
    private func setUpTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopWeatherViewCell.self, forCellReuseIdentifier: TopWeatherViewCell.description())
        tableView.register(LabelViewCell.self, forCellReuseIdentifier: LabelViewCell.description())
        
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
}

//MARK: - Actions
extension MainViewController {
    @objc private func updateCurrentWeather() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    @objc private func requestWeatherUpdate() {
        Task {
            let crntWeather = await weatherService.getCrntWeatherData(cityName: "수영구")
            DispatchQueue.main.async {
                self.updateWeatherInfo(crntWeather)
            }
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

//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("현재 위치: 위도 \(location.coordinate.latitude), 경도 \(location.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            
            Task {
                let weatherData = await weatherService.getCrntWeatherData(coordinate: .init(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
                DispatchQueue.main.async {
                    self.updateWeatherInfo(weatherData)
                }
            }
        }
    }
}

//MARK: - UITableView DataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopWeatherViewCell.description(), for: indexPath) as? TopWeatherViewCell else { return UITableViewCell() }
            cell.configure(.sunny, "17C", "부산")
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
            cell.mainTitle.text = 
                                """
                                                                                                                                                                                                                                                                                                                                  -------------------------

                                                                                                                                                여기다가

                                                                                                                                        날씨 디테일 뷰 추가 하면 될듯요.
                                                                                                                                                                                                                                                                                                -------------------------



"""
                                
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = .blue
            cell.mainTitle.text = "한국 지도 날씨"
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
            cell.contentView.backgroundColor = .red
            cell.mainTitle.text = "추가한 지역 목록"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - UITableView Delegate
extension MainViewController: UITableViewDelegate {
    
}


@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    return MainViewController()
}
