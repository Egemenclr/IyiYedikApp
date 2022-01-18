//
//  SearchViewControllerDataSource.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 18.01.2022.
//

import UIKit
import RxDataSources
import struct Common.RestModel

extension SearchVC {
    static func datasource() -> RxCollectionViewSectionedReloadDataSource<CollectionViewCellType>{
        return RxCollectionViewSectionedReloadDataSource<CollectionViewCellType> { dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .main(restaurant: let rest):
                let cell: SearchRestaurantsCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRestaurantsCell.identifier,
                                                                                    for: indexPath) as! SearchRestaurantsCell

                cell.configureUI(rest: rest)
                return cell
            case .empty:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.identifier, for: indexPath) as! EmptyCollectionViewCell
                return cell
            }
        }
    }
}

enum CollectionViewCellType {
    case mainType(title: String, items: [SectionItem])
    case emptyType(title: String, items:[SectionItem])
}

enum SectionItem {
    case main(restaurant: RestModel)
    case empty
}

extension CollectionViewCellType: SectionModelType {
    var items: [SectionItem] {
        switch self {
        case .mainType(title: _, items: let items):
            return items.map{$0}
        case .emptyType(title: _, items: let items):
            return items.map {$0}

        }
    }

    init(original: CollectionViewCellType, items: [SectionItem]) {
        switch original {
        case .mainType(let title, let items):
            self = .mainType(title: title, items: items)
        case .emptyType(let title, let items):
            self = .emptyType(title: title, items: items)
        }
    }
    
    typealias Item = SectionItem
}
