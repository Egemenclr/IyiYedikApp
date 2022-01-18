//
//  SearchBarViewController.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.01.2022.
//

import UIKit
import RxSwift
import RxCocoa
import Common

class SearchBarViewController: UIViewController {
    let disposeBag = DisposeBag()
    var comeFromSiparisVC: String?
    
    private lazy var searchView: SearchBarView = {
        let searchView = SearchBarView()
        return searchView
    }()
    
    //MARK: - Inputs
    let (indexSelectedObserver, indexSelectedEvent) = Driver<String>.pipe()
    //MARK: - Outputs
    let (searchResultObserver, searchResult) = Driver<[RestModel]>.pipe()
    let (isLoadingObserver, isLoading) = Driver<Bool>.pipe()
    
    //MARK: - Lifecycle
    override func loadView() {
        view = searchView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchView.searchBar.text = comeFromSiparisVC
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        comeFromSiparisVC = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchString = searchView.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance)
            .asObservable()
        
        let search = Observable.of(
            searchString,
            indexSelectedEvent.asObservable()
        )
            .merge()
            .distinctUntilChanged()

        let inputs = SearchViewModelInput(searchText: search)
        let viewModel = SearchViewModel(inputs)
        
        let outputs = viewModel.outputs(inputs)
        
        outputs.restaurant
            .drive(searchResultObserver)
            .disposed(by: disposeBag)

        outputs.isLoading
            .filter { !$0 }
            .drive(isLoadingObserver)
            .disposed(by: disposeBag)
        
        indexSelectedEvent.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { selected in
                self.searchView.searchBar.text = selected.element
            }
            .disposed(by: disposeBag)

        configureSearchController()
    }
    
    private func configureSearchController(){
        searchView.searchBar.placeholder = "Yemek, mutfak veya restoran arayın"
        definesPresentationContext = true
    }
}
