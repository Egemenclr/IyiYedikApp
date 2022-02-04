//
//  SearchViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.01.2022.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchViewModelInput {
    var searchText: Observable<String>
    var networkAPI: RestaurantAPIClient
}

struct SearchViewModelOutput {
    let isLoading: Driver<Bool>
    var restaurant: Driver<[RestModel]> = .never()
}

final class SearchViewModel {
    let isLoading = BehaviorSubject<Bool>(value: true)
    let restaurants = BehaviorRelay<[RestModel]>(value: [])
    let filteredRestaurants = BehaviorRelay<[RestModel]>(value: [])
    init(_ inputs: SearchViewModelInput) {
        
    }
    
    func outputs (
        _ inputs: SearchViewModelInput
    ) -> SearchViewModelOutput {
        return SearchViewModelOutput(
            isLoading: isLoadingOutput(isLoading),
            restaurant: getRestaurantListWithSearch(
                inputs.networkAPI,
                isLoading,
                filteredRestaurants,
                inputs.searchText
            )
        )
    }
}

func getRestaurantListWithSearch(
    _ api: RestaurantAPIClient,
    _ isLoading: BehaviorSubject<Bool>,
    _ filteredList: BehaviorRelay<[RestModel]>,
    _ text: Observable<String>
) -> Driver<[RestModel]> {
    let filtered = Observable
        .combineLatest(
            text,
            api.restaurants().asObservable()) { str, restaurants in
                return restaurants.filter { $0.restaurant.name.hasPrefix(str)}
            }.map { model -> [RestModel] in
                isLoading.onNext(false)
                filteredList.accept(model)
                return model
            }
    return filtered.asDriver(onErrorDriveWith: .never())
}

func isLoadingOutput(
    _ isLoading: BehaviorSubject<Bool>
) -> Driver<Bool> {
    isLoading
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: true)
}
