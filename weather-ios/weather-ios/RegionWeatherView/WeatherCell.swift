//
//  WeatherCell.swift
//  weather-ios
//
//  Created by YeongHo Ha on 2/8/24.
//

import UIKit

class WeatherCell: UITableViewCell {

    static let identifier = "WeatherCell"
    
    lazy var cityName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        return label
    }()
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        return label
    }()
    lazy var weather: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.backgroundColor = UIColor.lightGray
        self.backgroundView = UIView()
        self.selectedBackgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.clear
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
}


extension WeatherCell {
    private func setupViews() {
        contentView.addSubview(cityName)
        contentView.addSubview(temperature)
        contentView.addSubview(weather)
        //contentView.insertSubview(backgroundImage, at: 0)
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        cityName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        temperature.snp.makeConstraints { make in
            make.top.equalTo(cityName.snp.bottom).offset(30)
            make.left.equalTo(cityName.snp.left)
        }
        
        weather.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    func configure(with weatherData: CrntWeatherData) {
        cityName.text = weatherData.name
        temperature.text = "\(weatherData.main?.temp ?? 0)°C"
        weather.text = weatherData.weather?.first?.description ?? "날씨에 대한 정보를 가져올 수 없습니다."
        
    }
    
    
}
