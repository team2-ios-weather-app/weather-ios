//
//  MapViewController.swift
//  weather-ios
//
//  Created by 윤규호 on 2/5/24.
//

import UIKit
import NMapsMap

class MapViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.placeholder = "지역 검색"
        return searchbar
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
        addMarkers()
        
    }
    
    private func addSubView() {
        
        view.addSubview(naverMapView)
        view.addSubview(searchBar)
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            
            naverMapView.topAnchor.constraint(equalTo: self.searchBar.topAnchor),
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
    
    private func addMarkers() {
        // 시별 마커를 추가하는 함수
        
        // 각 시의 위치를 위한 위도와 경도 값
        let cityCoordinates: [(Double, Double)] = [
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
        
        // 마커 이미지 설정
        let markerImage = UIImage(named: "Sunny")
        let overlayImage = NMFOverlayImage(image: markerImage!) // UIImage를 NMFOverlayImage로 변환
        
        for (lat, lng) in cityCoordinates {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: lat, lng: lng)
            marker.iconImage = overlayImage
            marker.width = 30
            marker.height = 30
            marker.mapView = naverMapView
        }
    }
    
}
