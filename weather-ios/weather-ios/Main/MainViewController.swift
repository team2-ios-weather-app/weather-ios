//
//  ViewController.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

import UIKit

class MainViewController: UIViewController {
    var weatherService = WeatherService()
    var currentWeather: CrntWeatherData?
    private var tableView: UITableView!
    private var refreshControl = UIRefreshControl()
    private var mapWeatherButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let buttonImage = UIImage(systemName: "map", withConfiguration: config)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    private var regionListButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let buttonImage = UIImage(systemName: "list.clipboard.fill", withConfiguration: config)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "few clouds")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        setNavigationView()
        setUpTableView()
        setUpRefreshControl()
        updateWeatherInfo()
        setupButtons()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func setupButtons() {
        mapWeatherButton.addTarget(self, action: #selector(showMapWeather), for: .touchUpInside)
        regionListButton.addTarget(self, action: #selector(showRegionList), for: .touchUpInside)
        
        // 버튼 뷰에 추가
        view.addSubview(mapWeatherButton)
        view.addSubview(regionListButton)
        
        // 오토레이아웃 제약조건 설정
        mapWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        regionListButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapWeatherButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            mapWeatherButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            mapWeatherButton.widthAnchor.constraint(equalToConstant: 100),
            mapWeatherButton.heightAnchor.constraint(equalToConstant: 100),
        
            regionListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            regionListButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            regionListButton.widthAnchor.constraint(equalToConstant: 100),
            regionListButton.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        mapWeatherButton.layer.cornerRadius = 50  // 버튼의 둥근 모서리 반경 설정
        regionListButton.layer.cornerRadius = 50
    }
    
    @objc private func showMapWeather() {
        // 한국 지도 날씨 보기 기능 구현
        let mapVC = MapViewController()
        mapVC.modalPresentationStyle = .automatic
        present(mapVC, animated: true)
    }
    
    @objc private func showRegionList() {
        // 추가한 지역 목록 보기 기능 구현
        let regionVC = RegionWeatherVC()
        regionVC.modalPresentationStyle = .automatic
        present(regionVC, animated: true)
    }
}

extension MainViewController {
    private func setUpTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopWeatherViewCell.self, forCellReuseIdentifier: TopWeatherViewCell.description())
        tableView.register(LabelViewCell.self, forCellReuseIdentifier: LabelViewCell.description())
        tableView.backgroundColor = .clear
    }
    
    private func setNavigationView() {
        let unitToggleItem = {
            let item = UIBarButtonItem(title: "", primaryAction: .init(handler: { _ in
                UserSettings.shared.weatherUnitToggle()
                self.updateWeatherInfo()
            }))
            return item
        }()
        
        navigationItem.setRightBarButton(unitToggleItem, animated: true)
        navigationItem.title = "로딩중.."
    }
    
    private func updateWeatherInfo() {
        Task {
            currentWeather = await weatherService.getCrntWeatherData(regionName: UserSettings.shared.selectedRegion, unit: UserSettings.shared.weatherUnit) // 서비스용
            //            currentWeather = await WeatherService.testGetCrntWeatherData() // 테스트용
            
            DispatchQueue.main.async {
                self.navigationItem.title = self.currentWeather?.coord?.localNames?.ko
                self.navigationController?.navigationBar.tintColor = .green
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25),.foregroundColor: UIColor.white]
                self.navigationItem.rightBarButtonItem?.title = UserSettings.shared.weatherUnit == .metric ? " °F" : " °C"
                
                self.tableView.reloadData()
            }
        }
    }
    private func setUpRefreshControl() {
        // Configure refresh control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshWeatherData(_ sender: Any) {
        // Perform data refresh
        updateWeatherInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.refreshControl.endRefreshing()
        }
    }
}
//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopWeatherViewCell.description(), for: indexPath) as? TopWeatherViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let currentWeather = currentWeather {
                cell.weatherImageView.image = UIImage(named: currentWeather.weather?.first?.icon ?? "")
                cell.tempLabel.text = currentWeather.main?.temp?.description
                cell.tempLabel.text? += UserSettings.shared.weatherUnit == .metric ? " °C" : " °F"
                cell.descriptLabel.text = weatherService.getTheDescriptionKorVer(currentWeather.weather?.first?.description ?? "")
                
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            // 날씨 디테일 뷰에 온도, 습도, 풍속 정보 추가
            if let currentWeather = currentWeather {
                let tempUnit = UserSettings.shared.weatherUnit == .metric ? "°C" : "°F" // 온도 단위 설정
                let weatherDetailText = """
                최고온도: \(currentWeather.main?.tempMax ?? 0)\(tempUnit)
                최저온도: \(currentWeather.main?.tempMin ?? 0)\(tempUnit)
                습도: \(currentWeather.main?.humidity ?? 0)%
                """
                cell.mainTitle.text = weatherDetailText

            } else {
                cell.mainTitle.text = "날씨 정보가 없습니다."
            }
                    
            return cell
        default:
            return UITableViewCell()
        }
    }
}

@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    let naviVC = UINavigationController(rootViewController: MainViewController())
    return naviVC
}
