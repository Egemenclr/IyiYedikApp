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

protocol RestaurantMenuViewProtocol {
    var delegate: RestaurantMenuViewModelDelegate? { get set }
    var restaurants: BehaviorRelay<[RestaurantMenuModel]> { get }
    var numberOfItems: Int { get }
    
    func load(completion: @escaping ([RestaurantMenuModel]) -> Void)
}

protocol RestaurantMenuViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantMenuViewModel: RestaurantMenuViewProtocol {
    
    
    private let bag = DisposeBag()
    weak var delegate: RestaurantMenuViewModelDelegate?
    
    var restaurants = BehaviorRelay<[RestaurantMenuModel]>(value: [])
    
    init(){
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants.accept(list)
            //self.delegate?.reloadData()
        }
    }
    
    var numberOfItems: Int {
        restaurants.value.count
    }
    
    func load(completion: @escaping ([RestaurantMenuModel]) -> Void) {
        delegate?.registerCell()
        delegate?.reloadData()
        
        
         willChangeRestaurants { [weak self] (liste) in
             guard let self = self,
                 let list = liste else { return }
             self.restaurants.accept(list)
             completion(list)
             print("viewModel \(list)")
         }
    }
    
    func willChangeRestaurants(completion: @escaping ([RestaurantMenuModel]?) -> Void){
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        NetworkManager.shared.getFirebaseWithChild(entityName: "Basket",
                                                   child: uuid,
                                                   child2: "items",
                                                   type: RestaurantMenuModel.self).subscribe { single in
                                                    switch single {
                                                    case .success(let lists):
                                                        let filtered = lists.filter { word in
                                                            return word.isDeleted == false
                                                        }
                                                        completion(filtered)
                                                    case .failure(let error):
                                                        print(error)
                                                        completion(nil)
                                                    }
                                                   }.disposed(by: bag)
    }
}
