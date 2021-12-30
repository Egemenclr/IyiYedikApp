import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Common

struct SearchRestaurantViewModelInput {
    let indexSelected: Observable<IndexPath>
    let searchString: Observable<String>
}

struct SearchRestaurantViewModelOutput {
    let isLoading: Driver<Bool>
    var restaurant: Driver<[RestModel]> = .never()
    let showRestaurantDetail: Driver<RestaModel>
}

final class SearchRestaurantViewModel {
    let isLoading = BehaviorSubject<Bool>(value: true)
    let restaurants = BehaviorRelay<[RestModel]>(value: [])
    let filteredRestaurants = BehaviorRelay<[RestModel]>(value: [])
    init(_ inputs: SearchRestaurantViewModelInput) {
        
    }
    
    func outputs (
        _ inputs: SearchRestaurantViewModelInput
    ) -> SearchRestaurantViewModelOutput {
        return SearchRestaurantViewModelOutput(
            isLoading: isLoadingOutput(isLoading),
            restaurant: getRestaurantList(isLoading,
                                          restaurants,
                                          filteredRestaurants,
                                          inputs.searchString),
            showRestaurantDetail: showDetail(inputs,
                                             filteredRestaurants)
        )
    }
}

func getRestaurantList(
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

func showDetail(
    _ inputs: SearchRestaurantViewModelInput,
    _ restaurants: BehaviorRelay<[RestModel]>
) -> Driver<RestaModel> {
    inputs.indexSelected
        .withLatestFrom(restaurants) { ($0, $1 )}
        .map{ $1[$0.item].restaurant }
        .asDriver(onErrorDriveWith: .never())
}
