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
            showRestaurantDetail: showDetail(inputs)
        )
    }
}

func showDetail(
    _ inputs: SearchRestaurantViewModelInput
) -> Driver<RestaModel> {
    inputs.indexSelected
        .withLatestFrom(inputs.list) { ($0, $1 )}
        .map{ $1[$0.item].restaurant }
        .asDriver(onErrorDriveWith: .never())
}
