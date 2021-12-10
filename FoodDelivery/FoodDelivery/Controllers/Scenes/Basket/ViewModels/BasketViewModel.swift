//
//  RestaurantMenuViewModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 11.08.2021.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxRelay
import RxCocoa


// MARK: - IO Models
struct BasketViewModelInput {
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
}

final class BasketViewModel {
    let basketList = BehaviorRelay<[RestaurantMenuModel]>(value: [])
    let willDeleteIndex = BehaviorRelay<Int>(value: 0)
    init(_ inputs: BasketViewModelInput) {
        
        inputs
            .orderDeleteButtonTapped
            .subscribe { id in
                self.willDeleteIndex.accept(id)
            } onError: { err in
                #warning("make alert")
            }.disposed(by: inputs.bag)
        
        inputs
            .viewWillAppear
            .subscribe { _ in
                getRestaurants(self.basketList, inputs.bag)
            } onError: { err in
                print(err)
            }.disposed(by: inputs.bag)
        
        deleteOrder(inputs, self.basketList, willDeleteIndex)
        
    }
    
    func outputs(_ inputs: BasketViewModelInput) -> BasketViewModelOutput {
        return BasketViewModelOutput(
            foods: basketList.asDriver(onErrorJustReturn: []),
            showAlert: showDeleteAlert(inputs),
            showPayment: showPaymentVC(inputs, basketList),
            showEmptyView: showEmptyState(inputs)
        )
    }
}

func getRestaurants(
    _ orderList: BehaviorRelay<[RestaurantMenuModel]>,
    _ bag: DisposeBag) {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        NetworkManager.shared.getFirebaseWithChild(entityName: "Basket",
                                                   child: uuid,
                                                   child2: "items",
                                                   type: RestaurantMenuModel.self)
            .subscribe { single in
                switch single {
                case .success(let lists):
                    let filtered = lists.filter { word in
                        return word.isDeleted == false
                    }
                    orderList.accept(filtered)
                case .failure(let error):
                    print(error)
                }
            }.disposed(by: bag)
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
    _ index: BehaviorRelay<Int>) {
        inputs
            .deleteOrder
            .subscribe { element in
                NetworkManager.shared.deleteFood(index: index.value)
                getRestaurants(basketList, inputs.bag)
            } onError: { err in
                print(err)
            }.disposed(by: inputs.bag)
    }

private func showPaymentVC(
    _ inputs: BasketViewModelInput,
    _ orderList: BehaviorRelay<[RestaurantMenuModel]>
) -> Driver<[RestaurantMenuModel]> {
    inputs
        .orderButtonTapped
        .filter{
            orderList.value.count > 0
        }
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
