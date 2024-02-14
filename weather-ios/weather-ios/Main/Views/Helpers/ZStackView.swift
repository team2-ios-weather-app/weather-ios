//
//  ZStackView.swift
//  utilizing-coreData-mvvm
//
//  Created by JiHoon K on 1/26/24.
//

import UIKit

//class ZStackView: UIView {
//    
//    init() {
//        super.init(frame: .zero)
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addArrangedSubview(_ subView: UIView) {
//        addSubview(subView)
//        
//        subView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            subView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//        ])
//    }
//}

//class ZStackView: UIStackView {
//
//    init(spacing: CGFloat = 10, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .equalSpacing) {
//        super.init(frame: .zero)
//        self.axis = .vertical
//        self.spacing = spacing
//        self.alignment = alignment
//        self.distribution = distribution
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func addArrangedSubview(_ subView: UIView) {
//        addSubview(subView)
//        
//        subView.translatesAutoresizingMaskIntoConstraints = false
//        subView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        subView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//    }
//}

class ZStackView: UIStackView {
    
    enum Alignment {
        case center
        case top
        case bottom
        case leading
        case trailing
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func addArrangedSubview(_ view: UIView,_ alignment: Alignment = .center) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch alignment {
        case .center:
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        case .top:
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        case .leading:
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        case .trailing:
            NSLayoutConstraint.activate([
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
}
