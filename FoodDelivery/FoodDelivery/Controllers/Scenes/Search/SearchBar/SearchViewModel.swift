//
//  SearchViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.01.2022.
//

import Foundation
import RxSwift
import RxCocoa
import Common

struct SearchViewModelInput {
    let searchText: Observable<String>
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
                isLoading,
                restaurants,
                filteredRestaurants,
                inputs.searchText)
        )
    }
}

func getRestaurantListWithSearch(
    _ isLoading: BehaviorSubject<Bool>,
    _ restaurants: BehaviorRelay<[RestModel]>,
    _ filteredList: BehaviorRelay<[RestModel]>,
    _ text: Observable<String>
) -> Driver<[RestModel]> {
    NetworkLayer.getFirebase(entityName: "Restaurants", type: RestModel.self) { (result) in
        switch result{
        case .success(let lists):
            restaurants.accept(lists)
            isLoading.on(.next(false))
        case .failure(let error):
            print(error)
            restaurants.accept([])
        }
    }
    let filtered = Observable
        .combineLatest(text, restaurants) { str, restaurants in
            return restaurants.filter { $0.restaurant.name.hasPrefix(str)}
        }.map { model -> [RestModel] in
            filteredList.accept(model)
            return model
        }
    return filtered.asDriver(onErrorJustReturn: [])
}

func isLoadingOutput(
    _ isLoading: BehaviorSubject<Bool>
) -> Driver<Bool> {
    isLoading
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: true)
}
