//
//  CategoryListViewCell.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.01.2022.
//

import UIKit

class CategoryListViewCell: UICollectionViewCell {
    static let identifier = "CategoryListViewCell"
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let color: UIColor = .lightGray
        layer.cornerRadius = 4.0
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        
        configureNameLabel()
    }
    
    func setUI(text: String) {
        nameLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
