//
//  LabelViewCell.swift
//  weather-ios
//
//  Created by JiHoon K on 2/13/24.
//

import UIKit

class LabelViewCell: UITableViewCell {

    var mainTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let container = VStackView([
            mainTitle
        ])
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
}
