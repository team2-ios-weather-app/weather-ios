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
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        return label
    }()
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        return label
    }()
    lazy var tempMinMax: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.systemBlue
        return label
    }()
    lazy var weather: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }()
    lazy var time: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.systemBlue
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
}
// 서울
extension WeatherCell {
    func configure(with weatherData: CrntWeatherData) {
        cityName.text = weatherData.name
        temperature.text = "\(Int(weatherData.main?.temp ?? 0))°C"
        weather.text = weatherData.weather?.first?.description ?? "날씨에 대한 정보를 가져올 수 없습니다."
        tempMinMax.text = "최고 \(Int(weatherData.main?.tempMax ?? 0)) / 촤저 \(Int(weatherData.main?.tempMin ?? 0))"
        updateBackground(for: weatherData.weather?.first?.description ?? "")
    }
    
    private func updateBackground(for weather: String) {
        // 날씨 description에 따라 배경 업데이트.
        switch weather {
        case "맑음":
            backgroundImage.image = UIImage(named: "few clouds")
        case "튼구름":
            backgroundImage.image = UIImage(named: "few clouds")
        case "약간의 구름이 낀 하늘":
            backgroundImage.image = UIImage(named: "few clouds")
        case "보통 비":
            backgroundImage.image = UIImage(named: "few clouds")
        case "실 비":
            backgroundImage.image = UIImage(named: "few clouds")
        case "비":
            backgroundImage.image = UIImage(named: "few clouds")
        case "박무":
            backgroundImage.image = UIImage(named: "few clouds")
        case "눈":
            backgroundImage.image = UIImage(named: "few clouds")
        case "안개":
            backgroundImage.image = UIImage(named: "few clouds")
        case "온흐림":
            backgroundImage.image = UIImage(named: "few clouds")
        default:
            break
        }
        print("\(weather)")
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
        contentView.addSubview(time)
        
        
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
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        time.snp.makeConstraints { make in
            make.top.equalTo(cityName.snp.bottom).offset(5)
            make.left.equalTo(cityName.snp.left).offset(10)
        }
        
        weather.snp.makeConstraints { make in
            make.top.equalTo(time.snp.bottom).offset(10)
            make.left.equalTo(time.snp.left).offset(10)
        }
        
        temperature.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
        
        tempMinMax.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(temperature.snp.bottom).offset(10)
            
        }
        
        
    }
    
}



@available(iOS 17, *)
#Preview("", traits: .defaultLayout) {
    return RegionWeatherVC()
}
