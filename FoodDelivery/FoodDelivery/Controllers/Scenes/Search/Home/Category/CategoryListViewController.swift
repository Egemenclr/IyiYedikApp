//
//  CategoryListViewController.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.01.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CategoryListViewController: UIViewController {
    
    private lazy var viewSource: CategoryListView = {
        let view = CategoryListView(size: .popular)
        return view
    }()
    private let disposeBag = DisposeBag()
    
    //MARK: - I/O
    let (indexSelectedObserver, indexSelectedEvent) = Driver<String>.pipe()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = viewSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputs = CategoryListViewInput(indexSelected: viewSource.collectionView.rx.itemSelected.asObservable())
        let viewModel = CategoryListViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        
        let dataSource =
        RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: {(datasource,
                             collectionView,
                             indexPath,
                             itemViewModel) -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListViewCell.identifier,
                                                              for: indexPath) as! CategoryListViewCell
                
                cell.setUI(text: "\(itemViewModel.description)")
                return cell
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath)
            -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: CategoryListViewHeaderCell.identifier,
                                                                         for: indexPath) as! CategoryListViewHeaderCell
            switch indexPath.section {
            case 0:
                header.setText(type: .recent)
            case 1:
                header.setText(type: .popular)
            default:
                header.setText(type: .defaultText)
            }
            
            return header
        }
            
        outputs.dataSource
            .bind(to: viewSource.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        outputs.selectedCategory
            .drive(indexSelectedObserver)
            .disposed(by: disposeBag)
    }
}
