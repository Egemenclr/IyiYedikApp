import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Common
import UIKit


struct SiparisViewModelInput {
    let indexSelected: Observable<IndexPath>
    var networkAPI: CategoriesAPIClient
}
struct SiparisViewModelOutput {
    let isLoading: Driver<Bool>
    let restaurantList: Driver<[RestaurantGenreModel]>
    let showSearchVC: Driver<String>
}

final class SiparisViewModel {
    let isLoading = BehaviorSubject<Bool>(value: true)
    let restaurants = BehaviorRelay<[RestaurantGenreModel]>(value: [])
    
    init(_ inputs: SiparisViewModelInput) {
        
    }
    
    func outputs (_ inputs: SiparisViewModelInput) -> SiparisViewModelOutput {
        return SiparisViewModelOutput(
            isLoading: getIsLoadingOutput(isLoading),
            restaurantList: getRestaurants(
                inputs.networkAPI,
                isLoading,
                restaurants),
            showSearchVC: showSelectedIndex(inputs, self.restaurants)
        )
    }
}

func getRestaurants(
    _ api: CategoriesAPIClient,
    _ isLoading: BehaviorSubject<Bool>,
    _ restaurants: BehaviorRelay<[RestaurantGenreModel]>
) -> Driver<[RestaurantGenreModel]> {
    api.categoreis()
        .do(onSuccess: { lists in
            restaurants.accept(lists)
            isLoading.on(.next(false))            
        })
        .asDriver(onErrorDriveWith: .never())
}

func getIsLoadingOutput(
    _ isLoading: BehaviorSubject<Bool>
) -> Driver<Bool> {
    isLoading
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: true)
}

func showSelectedIndex (
    _ inputs: SiparisViewModelInput,
    _ restaurants: BehaviorRelay<[RestaurantGenreModel]>
) -> Driver<String> {
    return inputs.indexSelected
        .withLatestFrom(restaurants){ ($0, $1) }
        .map{ $1[$0.item].name }
        .asDriver(onErrorJustReturn: "damn")
}
