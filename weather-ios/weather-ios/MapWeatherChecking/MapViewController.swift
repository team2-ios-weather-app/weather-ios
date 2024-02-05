//
//  MapViewController.swift
//  weather-ios
//
//  Created by 윤규호 on 2/5/24.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupMap()
    }
    
    private func setupMap() {
        let locationManager = CLLocationManager()
        let naverMapView = NMFNaverMapView()
        naverMapView.showLocationButton = true //사용자 위치 트래킹
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On")
                locationManager.startUpdatingLocation()
                print(locationManager.location?.coordinate ?? "")
                // 현 위치로 카메라 이동
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude ?? 0, lng: locationManager.location?.coordinate.longitude ?? 0))
                cameraUpdate.animation = .easeIn
                
            } else {
                print("위치 서비스 Off")
            }
        }
        
        view.addSubview(naverMapView)
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            naverMapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            naverMapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            naverMapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

}

