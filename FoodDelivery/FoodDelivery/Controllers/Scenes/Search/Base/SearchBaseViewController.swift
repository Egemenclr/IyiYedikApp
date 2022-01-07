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
    
    lazy var searchBar = SearchBarViewController()
    private lazy var viewSource = SiparisView()
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
        
        searchBar.searchResult
            .drive(searchVC.restaurantListObservable)
            .disposed(by: disposeBag)
        
        
        let combineLoadings = combineLoadings(
            searchBar.isLoading,
            Driver.of(false)
        )
        
        combineLoadings
            .filter { !$0 }
            .do(onNext: { _ in self.loadingView.hideLoading() })
            .drive(loadingView.activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func configureViewStackView() {
        [
            searchBar,
            searchVC
        ].forEach {
            addChildController(controller: $0) {
                viewSource.stackView.addArrangedSubview($0)
            }
        }
    }
}

func combineLoadings(_ isLoadings: Driver<Bool>,
                     _ isLoading2: Driver<Bool>
) -> Driver<Bool> {
    Observable
        .combineLatest(isLoadings.asObservable(), isLoading2.asObservable())
        .flatMapLatest { (a, b) -> Observable<Bool> in
            Observable.of(a || b)
        }
        .asDriver(onErrorDriveWith: .never())
}

