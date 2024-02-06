//
//  ViewController.swift
//  weather-ios
//
//  Created by JiHoon K on 2/5/24.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let requestTestButton: UIButton = {
            let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
                WeatherService().getCrntWeatherData(lat: 37.4563, lon: 126.7052, completion: { data in
//                    print(data ?? "")
                    debugPrint(data ?? "")
                })
            }))

            button.setTitle("requestTestButton", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        view.addSubview(requestTestButton)
        
        NSLayoutConstraint.activate([
            requestTestButton.topAnchor.constraint(equalTo: view.topAnchor),
            requestTestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            requestTestButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            requestTestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}

