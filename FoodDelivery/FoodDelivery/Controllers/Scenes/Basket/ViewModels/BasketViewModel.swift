//
//  RestaurantMenuViewModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 11.08.2021.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa


// MARK: - IO Models
struct BasketViewModelInput {
    var api: BasketAPIClient = .live
    let orderButtonTapped: Observable<Void>
    let orderDeleteButtonTapped: Observable<Int>
    let emptyButtonTapped: Observable<Void>
    let deleteOrder: Observable<Void>
    let viewWillAppear: Observable<Void>
    let bag: DisposeBag
}

struct BasketViewModelOutput {
    let foods: Driver<[RestaurantMenuModel]>
    let showAlert: Driver<String>
    let showPayment: Driver<[RestaurantMenuModel]>
    let showEmptyView: Driver<Bool>
    let deleteOrderResponse: Driver<Bool>
}

final class BasketViewModel {
    let basketList = BehaviorRelay<[RestaurantMenuModel]>(value: [])
    let willDeleteIndex = BehaviorRelay<Int>(value: 0)
    private let (shouldGetBasketObserver, shouldGetBasketEvent) = Observable<Void>.pipe()
    init(_ inputs: BasketViewModelInput) {
        
        inputs
            .orderDeleteButtonTapped
            .subscribe { id in
                self.willDeleteIndex.accept(id)
            } onError: { err in
                #warning("make alert")
            }.disposed(by: inputs.bag)
        
        Observable.merge(
            inputs.viewWillAppear,
            shouldGetBasketEvent
        )
            .subscribe { _ in
                getRestaurants(inputs.api,
                               self.basketList,
                               inputs.bag)
            } onError: { err in
                print(err)
            }.disposed(by: inputs.bag)
    }
    
    func outputs(_ inputs: BasketViewModelInput) -> BasketViewModelOutput {
        return BasketViewModelOutput(
            foods: basketList.asDriver(onErrorJustReturn: []),
            showAlert: showDeleteAlert(inputs),
            showPayment: showPaymentVC(inputs, basketList),
            showEmptyView: showEmptyState(inputs),
            deleteOrderResponse: deleteOrder(inputs,
                                             self.basketList,
                                             willDeleteIndex,
                                             shouldGetBasketObserver
                                            )
        )
    }
}

func getRestaurants(
    _ api: BasketAPIClient,
    _ orderList: BehaviorRelay<[RestaurantMenuModel]>,
    _ bag: DisposeBag) {
        api.basket().asObservable()
            .subscribe { element in
                orderList.accept(element)
            }
            .disposed(by: bag)
    }

func showDeleteAlert(
    _ inputs: BasketViewModelInput
) -> Driver<String> {
    inputs
        .orderDeleteButtonTapped
        .map { _ in "Silmek istediğinize emin misiniz?" }
        .asDriver(onErrorDriveWith: .never())
}

private func deleteOrder(
    _ inputs: BasketViewModelInput,
    _ basketList: BehaviorRelay<[RestaurantMenuModel]>,
    _ index: BehaviorRelay<Int>,
    _ shouldGetBasketObserver: AnyObserver<Void>
) -> Driver<Bool> {
        inputs.deleteOrder
        .do(afterNext: { _ in
            shouldGetBasketObserver.on(.next(()))
        })
        .flatMapLatest { _ -> Single<Bool> in
            return inputs.api.deleteOrder(index.value)
        }
        .asDriver(onErrorDriveWith: .never())
    }

private func showPaymentVC(
    _ inputs: BasketViewModelInput,
    _ orderList: BehaviorRelay<[RestaurantMenuModel]>
) -> Driver<[RestaurantMenuModel]> {
    inputs
        .orderButtonTapped
        .filter{ orderList.value.isEmpty }
        .map{ _ in orderList.value }
        .asDriver(onErrorJustReturn: [] )
}

private func showEmptyState(
    _ inputs: BasketViewModelInput
) -> Driver<Bool> {
    inputs
        .emptyButtonTapped
        .map { _ in true }
        .asDriver(onErrorJustReturn: false)
}
