//
//  CategoryListView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.01.2022.
//

import UIKit

class CategoryListView: UIView {
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            layout.scrollDirection = .vertical
            layout.headerReferenceSize = CGSize(
                width: UIScreen.main.bounds.width,
                height: 30.0
            )
            return layout
        }()
        
        private(set) lazy var collectionView: UICollectionView = {
            let cView = UICollectionView(frame: .zero,
                                         collectionViewLayout: flowLayout)
            cView.backgroundColor = .systemBackground
            cView.register(CategoryListViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryListViewHeaderCell.identifier)
            cView.register(CategoryListViewCell.self,
                           forCellWithReuseIdentifier: CategoryListViewCell.identifier)
            

            cView.translatesAutoresizingMaskIntoConstraints = false
            cView.isScrollEnabled = false
            return cView
        }()
    
    var itemSize: CGSize
    
    init(size: CollectionViewSize) {
        itemSize = size.itemSize
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.alignFitEdges(padding: 5.0).forEach { constraint in
            constraint.isActive = true
        }
        let height = itemSize.height*7 + flowLayout.headerReferenceSize.height
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
