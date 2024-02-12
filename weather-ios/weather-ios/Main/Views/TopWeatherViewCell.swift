//
//  TopWeatherViewCell.swift
//  weather-ios
//
//  Created by JiHoon K on 2/13/24.
//

import UIKit

class TopWeatherViewCell: UITableViewCell {
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        return imageView
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let container = {
            let view = VStackView(spacing: 14, alignment: .fill, distribution: .fill,[
                weatherImageView,
                tempLabel,
                regionLabel,
                {
                    let view = UIView()
                    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    return view
                }()
            ])
            return view
        }()
        
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    
    func configure(_ weatherImage: UIImage,_ temp: String ,_ userLocation: String) {
        weatherImageView.image = weatherImage
        tempLabel.text = temp
        regionLabel.text = userLocation
    }
}
