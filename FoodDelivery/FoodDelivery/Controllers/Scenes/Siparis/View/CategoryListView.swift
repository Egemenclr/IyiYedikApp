//
//  CategoryListView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 16.12.2021.
//

import UIKit

class CategoryListView: UIView {
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: .zero,
                                     collectionViewLayout: flowLayout)
        cView.backgroundColor = .systemBackground
        cView.register(CategoriesCell.self,
                       forCellWithReuseIdentifier: CategoriesCell.identifier)
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.isScrollEnabled = false
        return cView
    }()

    var itemSize: CGSize
    
    init(size: CollectionViewSize) {
        itemSize = size.itemSize
        super.init(frame: .zero)
        
        addSubview(collectionView)
        collectionView.alignFitEdges().forEach { constraint in
            constraint.isActive = true
        }
        let height = calculateHeight(itemCount: 8)
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func calculateHeight(itemCount: UInt) -> CGFloat {
        guard itemCount > 0 else { return 0 }
        let columnCount = 2
        let itemSpacing = 5.0
        let rowCount = Int(ceil(Double(itemCount) / Double(columnCount)))
        let totalVerticalSpacing = itemSpacing * CGFloat(rowCount - 1)
        return (CGFloat(rowCount) * itemSize.height) + totalVerticalSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
