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
                Task {
                    let crntWeather = await WeatherService().getCrntWeatherData("수영구")
                    debugPrint(crntWeather ?? "")
                    DispatchQueue.main.async {
                        self.view.backgroundColor = .black
                    }
                }
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

@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
  return MainViewController()
}
