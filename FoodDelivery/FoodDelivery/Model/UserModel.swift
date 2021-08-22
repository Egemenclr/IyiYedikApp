//
//  UserModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 22.08.2021.
//

import Foundation


struct User: Decodable {
    
    let name: String
    let surname: String
    let cardNumber: String
    let expireDate: String
    let CCV: String
    let adress: AddressModel
}

struct AddressModel: Decodable{
    let title: String
    let adressDesc: String
    let buildingNumber: String
    let flat: String
    let apartmentNumber: String
    let description: String
}
