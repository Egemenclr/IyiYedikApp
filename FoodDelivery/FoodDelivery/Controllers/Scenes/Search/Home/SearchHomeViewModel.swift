import Foundation
import RxSwift
import RxRelay
import RxCocoa

struct SearchRestaurantViewModelInput {
    var indexSelected: Observable<IndexPath> = .never()
    var list: Observable<[RestModel]> = .never()
}

struct SearchRestaurantViewModelOutput {
    let showRestaurantDetail: Driver<RestaModel>
    let showEmptyView: Driver<Bool>
    let sections: Driver<[CollectionViewCellType]>
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
            showEmptyView: showEmptyView(inputs.list),
            sections: configureSections(inputs)
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
        .map({ $0.isEmpty })
        .asDriver(onErrorDriveWith: .never())
}

func configureSections(
    _ inputs: SearchRestaurantViewModelInput
) -> Driver<[CollectionViewCellType]> {
    inputs.list
        .map({
            guard $0.count > 0 else {
                return [CollectionViewCellType.emptyType(title: "", items: [.empty])]
            }
            return $0.map { CollectionViewCellType.mainType(title: "", items: [.main(restaurant: $0)]) }
        })
        .asDriver(onErrorDriveWith: .never())
}
