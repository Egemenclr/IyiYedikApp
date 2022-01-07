//
//  SearchBarView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.01.2022.
//

import UIKit

class SearchBarView: UIView {
    private let topSpaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.isHidden = true
        return view
    }()
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.enablesReturnKeyAutomatically = true
        bar.returnKeyType = .search
        bar.placeholder = "Ara"
        bar.barTintColor = .systemRed
        bar.backgroundColor = .systemRed
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(topSpaceView)
        stackView.addArrangedSubview(searchBar)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
            
        addSubview(stackView)
        let topInset = UIApplication.shared.keyWindow?.safeAreaInsets.top
        let height = topInset == 0 ? 20.0 : topInset
        
        NSLayoutConstraint.activate(stackView.alignFitEdges())
        NSLayoutConstraint.activate([
            topSpaceView.heightAnchor.constraint(equalToConstant: height ?? 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
