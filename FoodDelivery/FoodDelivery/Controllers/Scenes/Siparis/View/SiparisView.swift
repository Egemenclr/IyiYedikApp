//
//  MarketSiparisView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 20.12.2021.
//

import UIKit

class SiparisView: UIView {
    
    var scrollView: UIScrollView = {
        let sView = UIScrollView()
        sView.alwaysBounceVertical = true
        sView.translatesAutoresizingMaskIntoConstraints = false
        return sView
    }()
    
    var stackView: UIStackView = {
        let sView = UIStackView()
        sView.distribution = .fill
        sView.alignment = .fill
        sView.spacing = 5.0
        sView.axis = .vertical
        sView.translatesAutoresizingMaskIntoConstraints = false
        return sView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollView.alignFitEdges())
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
        ])
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
