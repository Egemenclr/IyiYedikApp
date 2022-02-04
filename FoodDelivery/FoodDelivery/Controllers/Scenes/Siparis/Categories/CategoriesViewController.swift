//
//  CategoriesViewController.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 28.12.2021.
//

import UIKit
import RxSwift
import RxCocoa

class CategoriesViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    private let loadingView = LoadingView()
    let containerView = CategoriesListView(size: .category)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()
        
        let indexSelected = containerView.collectionView.rx.itemSelected
            .asObservable()
        let api: CategoriesAPIClient = .live
        let inputs = SiparisViewModelInput(
            indexSelected: indexSelected,
            networkAPI: api
        )
        let viewModel = SiparisViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        loadingView.startLoading()
        
        outputs.restaurantList
            .drive(containerView.collectionView.rx.items(cellIdentifier: CategoriesCell.identifier, cellType: CategoriesCell.self)) { index, restaurant, cell in
                cell.setUI(model: restaurant)
            }.disposed(by: bag)
        
        outputs.isLoading
            .filter { !$0 }
            .do(onNext: { _ in self.loadingView.hideLoading() })
            .drive(loadingView.activityIndicator.rx.isHidden)
            .disposed(by: bag)

        outputs.showSearchVC
                .drive(rx.showSearchViewControllerWithTitle)
                .disposed(by: bag)

        Connectivity.isStillConnecting.subscribe{ value in
            switch value {
            case .success(_):
                print("internetConnection: \(value)")
            case .failure(_):
                let offlineVC = OfflineVC()
                self.present(offlineVC, animated: true)
            }
        }.disposed(by: bag)
                
        configureViewStackView()
        
        
        navigationController?.view.backgroundColor = .systemRed
        
        //DatabaseManager.shared.save(Favories(name: "Muhit Burger"))
        //print(DatabaseManager.shared.favorites)
        //DatabaseManager.shared.find(Favories(name: "q"))
        let damn = DatabaseManager.shared.favorites.filter{
            $0.restaurantName.prefix(0) == "q"
        }
    }
    
    private func configureViewStackView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(containerView.alignFitEdges())
    }
}
