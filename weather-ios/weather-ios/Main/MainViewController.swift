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
        
        setUpTableView()
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        Task {
            
            currentWeather = WeatherService.testGetCrntWeatherData() // 테스트용

            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
}

//MARK: - Actions
extension MainViewController {
    
}

//MARK: - UITableView DataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            print(currentWeather?.main?.temp?.description ?? " dasdsa")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopWeatherViewCell.description(), for: indexPath) as? TopWeatherViewCell else { return UITableViewCell() }
            cell.regionLabel.text = currentWeather?.coord?.localNames?.ko ?? "로딩중.."
            cell.weatherImageView.image = UIImage(named: currentWeather?.weather?.first?.icon ?? "")
            cell.tempLabel.text = currentWeather?.main?.temp?.description ?? "로딩중.."
            cell.descriptLabel.text = currentWeather?.weather?.first?.description
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
            cell.mainTitle.text = "한국 지도 날씨"
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelViewCell.description(), for: indexPath) as? LabelViewCell else { return UITableViewCell() }
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
