//
//  SearchListView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 15.12.2021.
//

import UIKit

class SearchListView: UIView {
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .systemBackground
        cView.register(
            SearchRestaurantsCell.self,
            forCellWithReuseIdentifier: SearchRestaurantsCell.identifier
        )
        cView.backgroundColor = .systemBlue
        cView.isScrollEnabled = false
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()
    
    let itemSize: CGSize
    
    init(with size: CollectionViewSize) {
        self.itemSize = size.itemSize
        super.init(frame: .zero)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.alignFitEdges())
        
        let height = calculateHeight(itemCount: 9)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
