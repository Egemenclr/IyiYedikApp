//
//  DatabaseManager.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 7.11.2021.
//

import Foundation
import RealmSwift

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    var favorites: Results<Favories> {
        return realm.objects(Favories.self)
    }
    
    func find(_ resturant: Favories) {
        let deneme = favorites.filter{
            $0.restaurantName.contains("p")
        }
    }
    
    func save(_ restaurant: Favories) {
        do {
            try realm.write {
                realm.add(restaurant)
            }
        } catch {
            print("An error occurred while saving the category: \(error)")
        }
    }
    
    func delete(_ restaurant: Favories) {
        do {
            try realm.write {
                try realm.write {
                    realm.delete(restaurant)
                }
            }
        } catch {
            print("An error occurred while deleting the item: \(error)")
        }
    }
}
