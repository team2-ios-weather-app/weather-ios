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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationView()
        setUpTableView()
        updateWeatherInfo()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

extension MainViewController {
    private func setUpTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopWeatherViewCell.self, forCellReuseIdentifier: TopWeatherViewCell.description())
        tableView.register(LabelViewCell.self, forCellReuseIdentifier: LabelViewCell.description())
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
//            currentWeather = await weatherService.getCrntWeatherData(regionName: UserSettings.shared.selectedRegion, unit: UserSettings.shared.weatherUnit) // 서비스용
            currentWeather = await WeatherService.testGetCrntWeatherData() // 테스트용
            
            DispatchQueue.main.async {
                self.navigationItem.title = self.currentWeather?.coord?.localNames?.ko
                self.navigationItem.rightBarButtonItem?.title = UserSettings.shared.weatherUnit == .metric ? " °C" : " °F"
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopWeatherViewCell.description(), for: indexPath) as? TopWeatherViewCell else { return UITableViewCell() }
            if let currentWeather = currentWeather {
                cell.weatherImageView.image = UIImage(named: currentWeather.weather?.first?.icon ?? "")
                cell.tempLabel.text = currentWeather.main?.temp?.description
                cell.tempLabel.text? += UserSettings.shared.weatherUnit == .metric ? " °C" : " °F"
                cell.descriptLabel.text = currentWeather.weather?.first?.description
            }
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
            cell.mainTitle.text = "한국 지도 날씨 보기"
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
            cell.mainTitle.text = "추가한 지역 목록 보기"
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let alloedCell: Set<Int> = [2, 3]
        if alloedCell.contains(indexPath.row) {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 2:
            let mapVC = MapViewController()
            present(mapVC, animated: true)
        case 3:
            let regionVC = RegionWeatherVC()
            present(regionVC, animated: true)
        default:
            return
        }
    }
}

@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    let naviVC = UINavigationController(rootViewController: MainViewController())
    return naviVC
}
