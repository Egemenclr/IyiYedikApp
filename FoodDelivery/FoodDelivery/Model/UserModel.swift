//
//  UserModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 22.08.2021.
//

import Foundation
import RealmSwift

struct User: Decodable {
    
    var name: String
    var surname: String
    var cardNumber: String
    var expireDate: String
    var CCV: String
    var adress: AddressModel
}

struct AddressModel: Decodable{
    var title: String
    var adressDesc: String
    var buildingNumber: String
    var flat: String
    var apartmentNumber: String
    var description: String
}


class Favories: Object {
    @Persisted var restaurantName: String = ""
    
    convenience init(name: String) {
        self.init()
        self.restaurantName = name
    }
}

extension User {
    static var empty: User = {
        return User(name: "", surname: "", cardNumber: "", expireDate: "", CCV: "", adress: AddressModel.empty)
    }()
}

extension AddressModel {
    func toString() -> String {
        "\(self.adressDesc) Bina No:\(self.buildingNumber) Kat:\(self.flat) İç Kapı:\(self.apartmentNumber) - \(self.description)"
    }
    
    static var empty: AddressModel {
        return AddressModel(title: "", adressDesc: "", buildingNumber: "", flat: "", apartmentNumber: "", description: "")
    }
}
