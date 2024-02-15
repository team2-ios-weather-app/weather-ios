//
//  MapViewController.swift
//  weather-ios
//
//  Created by 윤규호 on 2/5/24.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController {
    // 각 시의 위치를 위한 위도와 경도 값
    private let cityCoordinates: [(Double, Double)] = [
        (37.4563, 126.7052), // 인천
        (37.5665, 126.9780), // 서울
        (37.8859, 127.7347), // 춘천
        (38.2070, 128.5915), // 속초
        (37.7519, 128.8762), // 강릉
        (37.3494, 127.9505), // 원주
        (36.7847, 126.4506), // 서산
        (36.8214, 127.1523), // 천안
        (36.3504, 127.3845), // 대전
        (37.1326, 128.2141), // 제천
        (34.8092, 126.3943), // 목포
        (35.9451, 126.9542), // 군산
        (35.8242, 127.1480), // 전주
        (36.1194, 128.3445), // 구미
        (35.8714, 128.6014), // 대구
        (35.8563, 129.2246), // 경주
        (36.0424, 129.3644), // 포항
        (35.1595, 126.8526), // 광주
        (34.7604, 127.6622), // 여수
        (35.1796, 128.9967), // 진주
        (35.2383, 128.6926), // 창원
        (35.1796, 129.0756), // 부산
        (35.5384, 129.3114), // 울산
        (33.3626, 126.5312)  // 제주
        // 필요에 따라 다른 도시들의 좌표도 추가
    ]
    var weatherService = WeatherService()
    private var markers: [NMFMarker] = []
    private var statusForMap: Int = 0 // flag 기능을 위한 변수. 0: default, 1: 저장된 지역 날씨 보기, 2: 전체 지역 날씨 보기
    
    private let myMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("📍 저장된 지역 날씨 보기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(target, action: #selector(myMapShow), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let totalMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("🌍 전체 지역 날씨 보기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(target, action: #selector(totalMapShow), for: .touchUpInside)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let updateMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Update"), for: .normal)
        button.addTarget(target, action: #selector(updateMapShow), for: .touchUpInside)
        return button
    }()
    
    private let naverMapView: NMFMapView = {
        let mapView = NMFMapView() // 지도 객체 생성
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomGestureEnabled = true // Option + 트랙패드 클릭 후 좌우 제스처(핀치 제스처)로 화면 확대 및 축소
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubView()
        setupMap()
        setupUI()
    }
    
    private func addSubView() {
        
        view.addSubview(naverMapView)
        view.addSubview(myMapButton)
        view.addSubview(totalMapButton)
        view.addSubview(updateMapButton)
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            myMapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myMapButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            myMapButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: -5),
            
            totalMapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalMapButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 5),
            totalMapButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            
            updateMapButton.topAnchor.constraint(equalTo: self.naverMapView.topAnchor, constant: 5),
            updateMapButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -5),
            updateMapButton.widthAnchor.constraint(equalToConstant: 35),
            updateMapButton.heightAnchor.constraint(equalToConstant: 35),
            
            naverMapView.topAnchor.constraint(equalTo: self.myMapButton.bottomAnchor, constant: 10),
            naverMapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            naverMapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            naverMapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setupMap() {
        naverMapView.zoomLevel = 6 // 처음 빌드 시에 보여질 화면의 줌 레벨
        
        //초기 보여지는 화면의 중심 위도/경도 값
        let latitude = 36.42367424038887
        let longitude = 127.4749859399598
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        naverMapView.moveCamera(cameraUpdate)
    }
    
    @objc
    private func myMapShow() {
        clearMap()
        statusForMap = 1
        
        print(UserSettings.shared.registeredRegions)
        for cityName in UserSettings.shared.registeredRegions {
            Task {
                let crntWeather = await weatherService.getCrntWeatherData(regionName: cityName, unit: .metric)
                let markerImage = UIImage(named: crntWeather?.weather?.first?.icon ?? "")
                let overlayImage = NMFOverlayImage(image: markerImage!) // UIImage를 NMFOverlayImage로 변환
                let marker = NMFMarker()
                let coordinate = await weatherService.getCoordinateFor(cityName)
                
                marker.position = NMGLatLng(lat: coordinate!.lat, lng: coordinate!.lon)
                marker.iconImage = overlayImage
                marker.width = 30
                marker.height = 30
                marker.mapView = self.naverMapView
                
                self.markers.append(marker)
            }
        }
    }
    
    @objc
    private func totalMapShow() {
        clearMap()
        statusForMap = 2
        
        for coordinate in cityCoordinates {
            let coordinate = Coordinate(lat: coordinate.0, lon: coordinate.1)
            Task {
                let crntWeather = await weatherService.getCrntWeatherData(coordinate: coordinate, unit: .metric)
                let markerImage = UIImage(named: crntWeather?.weather?.first?.icon ?? "")
                let overlayImage = NMFOverlayImage(image: markerImage!) // UIImage를 NMFOverlayImage로 변환
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: coordinate.lat, lng: coordinate.lon)
                marker.iconImage = overlayImage
                marker.width = 30
                marker.height = 30
                marker.mapView = self.naverMapView
                
                self.markers.append(marker)
            }
        }
    }
    
    @objc
    private func updateMapShow() {
        switch statusForMap {
        case 0: break // 기본 상태 : 지도에 아무 마커도 띄우지 않은 상태
        case 1: myMapShow()
        case 2: totalMapShow()
        default: break
        }
    }
    
    private func clearMap() {
        for marker in markers {
            marker.mapView = nil
        }
        markers.removeAll()
    }
    
}
