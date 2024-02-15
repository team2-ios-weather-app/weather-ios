//
//  WeatherCell.swift
//  weather-ios
//
//  Created by YeongHo Ha on 2/8/24.
//

import UIKit
import SnapKit

class WeatherCell: UITableViewCell {

    static let identifier = "WeatherCell"
    lazy var cellView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textColor = UIColor.white
        label.shadowColor = UIColor.darkGray // 텍스트 그림자
        label.shadowOffset = CGSize(width: 2, height: 2)
        return label
    }()
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = UIColor.white
        
        return label
    }()
    lazy var tempMinMax: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.white
        
        return label
    }()
    lazy var weather: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        label.numberOfLines = 2 // Keep as is for multiline text
        label.textAlignment = .center
        return label
    }()
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    var clear: [String] = ["clear sky"]
    var fewClouds: [String] = ["few clouds", "scattered clouds", "broken clouds", "overcast clouds"]
    var rain: [String] = ["rain", "shower rain", "light intensity drizzle", "drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle", "light rain", "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain", "freezing rain", "light intensity shower rain", "    shower rain", "heavy intensity shower rain", "ragged shower rain"]
    var thunderstorm: [String] = ["thunderstorm", "thunderstorm with light rain", "thunderstorm with rain", "thunderstorm with heavy rain", "light thunderstorm", "thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle"]
    var clouds: [String] = ["scattered clouds", "broken clouds", ]
    var snow: [String] = ["snow", "light rain and snow", "light snow", "heavy snow", "sleet", "light shower sleet", "shower sleet", "light rain and snow", "rain and snow", "light shower snow", "shower snow", "heavy shower snow"]
    var mist: [String] = ["mist", "smoke", "haze", "sand/dust whirls", "fog", "sand", "dust", "volcanic ash", "squalls", "tornado"]
}
// 서울 오사카
extension WeatherCell {
    func configure(with weatherData: CrntWeatherData) {
        backgroundColor = UIColor.clear
        cityName.text = weatherData.coord?.localNames?.ko ?? ""
        temperature.text = "\(Int(weatherData.main?.temp ?? 0)) °C"
        if let weatherDescriptionEng = weatherData.weather?.first?.description {
            weather.text = getTheDescriptionKorVer(weatherDescriptionEng)
        } else {
            weather.text = "날씨 정보 없음"
        }
        tempMinMax.text = "최고 \(Int(weatherData.main?.tempMax ?? 0))°C / 촤저 \(Int(weatherData.main?.tempMin ?? 0))°C"
        updateBackground(for: weatherData.weather?.first?.description ?? "")
        
        contentView.backgroundColor = UIColor.clear
    }
    
    private func updateBackground(for weather: String) {
        // 날씨 description에 따라 배경 업데이트.
        switch weather {
        case _ where clear.contains(weather):
            backgroundImage.image = UIImage(named: "clear")
        case _ where fewClouds.contains(weather):
            backgroundImage.image = UIImage(named: "clouds")
        case _ where rain.contains(weather):
            backgroundImage.image = UIImage(named: "rain")
        case _ where thunderstorm.contains(weather):
            backgroundImage.image = UIImage(named: "thunderstorm")
        case _ where clouds.contains(weather):
            backgroundImage.image = UIImage(named: "clouds")
        case _ where snow.contains(weather):
            backgroundImage.image = UIImage(named: "snow")
        case _ where mist.contains(weather):
            backgroundImage.image = UIImage(named: "mist")
        default:
            backgroundImage.image = UIImage(named: "clear")
            break
        }
        print("날씨 정보: \(weather)")
    }
    
    
}

extension WeatherCell {
    
    
    private func setupViews() {
        contentView.insertSubview(backgroundImage, at: 0)
        contentView.addSubview(cellView)
        contentView.addSubview(cityName)
        contentView.addSubview(temperature)
        contentView.addSubview(weather)
        contentView.addSubview(tempMinMax)
        
        
        
        cellView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        cityName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(40)
        }
        
        weather.snp.makeConstraints { make in
            make.top.equalTo(cityName.snp.bottom).offset(5)
            make.left.equalTo(cityName.snp.left)
            make.width.equalTo(100)
        }
        
        temperature.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(25)
            make.width.equalTo(120)
        }
        
        tempMinMax.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(temperature.snp.bottom).offset(10)
            
        }
        
        
    }
    
}

extension WeatherCell {
    func getTheDescriptionKorVer(_ engVer: String) -> String {
        switch engVer {
        case "clear sky": "맑은 하늘"
        case "few clouds": "구름 조금"
        case "scattered clouds": "조각 구름"
        case "broken clouds": "부서진 구름"
        case "shower rain": "소나기"
        case "rain": "비"
        case "thunderstorm": "천둥번개"
        case "snow": "눈"
        case "mist": "안개"
        case "thunderstorm with light rain": "약한 비를 동반한 천둥번개"
        case "thunderstorm with rain": "비를 동반한 천둥번개"
        case "thunderstorm with heavy rain": "강한 비를 동반한 천둥번개"
        case "light thunderstorm": "약한 천둥번개"
        case "heavy thunderstorm": "강한 천둥번개"
        case "ragged thunderstorm": "불규칙적인 천둥번개"
        case "thunderstorm with light drizzle": "약한 이슬비를 동반한 천둥번개"
        case "thunderstorm with drizzle": "이슬비를 동반한 천둥번개"
        case "thunderstorm with heavy drizzle": "강한 이슬비를 동반한 천둥번개"
        case "light intensity drizzle": "약한 이슬비"
        case "drizzle": "이슬비"
        case "heavy intensity drizzle": "강한 이슬비"
        case "light intensity drizzle rain": "약한 이슬비 비"
        case "drizzle rain": "이슬비 비"
        case "heavy intensity drizzle rain": "강한 이슬비 비"
        case "shower rain and drizzle": "소나기와 이슬비"
        case "heavy shower rain and drizzle": "강한 소나기와 이슬비"
        case "shower drizzle": "소나기 이슬비"
        case "light rain": "약한 비"
        case "moderate rain": "중간 비"
        case "heavy intensity rain": "강한 비"
        case "very heavy rain": "매우 강한 비"
        case "extreme rain": "극심한 비"
        case "freezing rain": "얼어붙는 비"
        case "light intensity shower rain": "약한 소나기 비"
        case "heavy intensity shower rain": "강한 소나기 비"
        case "ragged shower rain": "불규칙적인 소나기 비"
        case "light snow": "약한 눈"
        case "heavy snow": "강한 눈"
        case "sleet": "진눈깨비"
        case "light shower sleet": "약한 진눈깨비 소나기"
        case "shower sleet": "진눈깨비 소나기"
        case "light rain and snow": "약한 비와 눈"
        case "rain and snow": "비와 눈"
        case "light shower snow": "약한 눈 소나기"
        case "shower snow": "눈 소나기"
        case "heavy shower snow": "강한 눈 소나기"
        case "smoke": "연기"
        case "haze": "안개"
        case "sand/dust whirls": "모래/먼지 회오리"
        case "fog": "안개"
        case "sand": "모래"
        case "dust": "먼지"
        case "volcanic ash": "화산재"
        case "squalls": "돌풍"
        case "tornado": "토네이도"
        default: ""
        }
    }
}

@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    return RegionWeatherVC()
}
