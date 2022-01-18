import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Common

struct SearchRestaurantViewModelInput {
    let indexSelected: Observable<IndexPath>
    let list: Observable<[RestModel]>
}

struct SearchRestaurantViewModelOutput {
    let showRestaurantDetail: Driver<RestaModel>
    let showEmptyView: Driver<Bool>
}

final class SearchRestaurantViewModel {
    let restaurants = BehaviorRelay<[RestModel]>(value: [])
    let filteredRestaurants = BehaviorRelay<[RestModel]>(value: [])
    init(_ inputs: SearchRestaurantViewModelInput) {
        
    }
    
    func outputs (
        _ inputs: SearchRestaurantViewModelInput
    ) -> SearchRestaurantViewModelOutput {
        return SearchRestaurantViewModelOutput(
            showRestaurantDetail: showDetail(inputs),
            showEmptyView: showEmptyView(inputs.list)
        )
    }
}

func showDetail(
    _ inputs: SearchRestaurantViewModelInput
) -> Driver<RestaModel> {
    inputs.indexSelected
        .withLatestFrom(inputs.list) { ($0, $1 )}
        .map{ $1[$0.section].restaurant }
        .asDriver(onErrorDriveWith: .never())
}

func showEmptyView(
    _ restaurantList: Observable<[RestModel]>
) -> Driver<Bool>{
    restaurantList
        .skip(1)
        .map({ $0.count == 0 })
        .asDriver(onErrorDriveWith: .never())
}
