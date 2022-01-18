//
//  EmptyCollectionViewCell.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 14.01.2022.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    static let identifier = "EmptyCollectionViewCell"
    
    private lazy var emptyView = EmptyViewState(image: Images.emptyBasket!,
                                           messageText: "Ürün bulunmamaktadır.",
                                           messageDesc: "Aradığınız kriterlere uygun sonuç bulunamadı."
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(emptyView)
        emptyView.setButton(text: "Ürün önermek ister misiniz?", backgroundColor: .systemGreen)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
            emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0),
            emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0)
        ])
    }
}
