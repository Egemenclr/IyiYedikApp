//
//  SearchBaseViewController.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.01.2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    private let loadingView = LoadingView()
    
    private lazy var viewSource = SiparisView()
    lazy var searchBar = SearchBarViewController()
    private lazy var recentSearchView = CategoryListViewController()
    private lazy var searchVC = SearchVC()
    
    
    
    // MARK: - Lifecycle
    override func loadView() {
        view = viewSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureViewStackView()
        
        loadingView.startLoading()
        
        
        let combineLoadings = combineLoadings(
            [
                searchBar.isLoading,
                Driver.of(false)
            ]
        )
        
        disposeBag.insert(
            recentSearchView.indexSelectedEvent.drive(searchBar.indexSelectedObserver),
            searchBar.searchResult.drive(searchVC.restaurantListObservable),
            
            combineLoadings
                .filter { !$0 }
                .do(onNext: { _ in self.loadingView.hideLoading() })
                .drive(loadingView.activityIndicator.rx.isHidden)
        )
    }

    private func configureViewStackView() {
        [
            searchBar,
            recentSearchView,
            searchVC
        ].forEach {
            addChildController(controller: $0) {
                viewSource.stackView.addArrangedSubview($0)
            }
        }
    }
}

func combineLoadings(_ isLoadings: [Driver<Bool>])
-> Driver<Bool> {
    Observable
        .combineLatest(isLoadings.map({ $0.asObservable() }))
        .flatMapLatest { boolList -> Observable<Bool> in
            Observable.of(boolList.contains(true))
        }
        .asDriver(onErrorDriveWith: .never())
}

