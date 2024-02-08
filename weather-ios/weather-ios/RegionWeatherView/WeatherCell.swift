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
        label.font = UIFont.boldSystemFont(ofSize: 24)
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
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
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
    }
    
    func configure(with weatherData: CrntWeatherData) {
        cityName.text = weatherData.name
        temperature.text = "\(weatherData.main?.temp ?? 0)°C"
        weather.text = weatherData.weather?.description
        
        //
    }
    
    
}
