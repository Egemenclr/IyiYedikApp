//
//  RestaurantMenuViewModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 11.08.2021.
//

import Foundation
import FirebaseAuth

protocol RestaurantMenuViewProtocol {
    var delegate: RestaurantMenuViewModelDelegate? { get set }
    var restaurants: [RestaurantMenuModel] { get }
    var numberOfItems: Int { get }
    
    func load()
}

protocol RestaurantMenuViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantMenuViewModel: RestaurantMenuViewProtocol {
    weak var delegate: RestaurantMenuViewModelDelegate?
    
    var restaurants: [RestaurantMenuModel] = []
    
    init(){
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants = list
            //self.delegate?.reloadData()
        }
    }
    
    var numberOfItems: Int {
        restaurants.count
    }
    
    func load() {
        delegate?.registerCell()
        delegate?.reloadData()
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants = list
            //self.delegate?.reloadData()
        }
    }
    
    
    func willChangeRestaurants(completion: @escaping ([RestaurantMenuModel]?) -> Void){
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        NetworkManager.shared.getFirebaseWithChild(entityName: "Basket", child: uuid, child2: "items",type: RestaurantMenuModel.self) { (result) in
            switch result{
            case .success(let lists):
                let filtered = lists.filter { word in
                    return word.isDeleted == false
                }
                completion(filtered)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
