//
//  CategoryListViewHeaderCell.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.01.2022.
//

import UIKit

class CategoryListViewHeaderCell: UICollectionReusableView {
    static let identifier = "CategoryListViewHeaderCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.text = "deneme"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
    }
    
    func setText(type: HeaderType){
        label.text = type.text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        addSubview(label)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
            
            divider.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2.0),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2.0),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2.0),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0)
        ])
    }
}

enum HeaderType  {
    case popular
    case recent
    case defaultText
    
    var text: String {
        switch self {
        case .popular:
            return "Popüler Aramalar"
        case .recent:
            return "Geçmiş Aramalarım"
        case .defaultText:
            return "damn"
        }
    }
}
