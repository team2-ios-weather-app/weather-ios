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
    
    let descriptLabel: UILabel = {
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
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let container = {
            let view = VStackView(spacing: 14, alignment: .center, distribution: .fill,[
                regionLabel,
                weatherImageView,
                HStackView(alignment: .center, distribution: .fillEqually, [
                    tempLabel,
                    descriptLabel,
                ]),
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
}
