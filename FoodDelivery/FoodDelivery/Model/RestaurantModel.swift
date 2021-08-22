//
//  RestaurantModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 10.08.2021.
//

import Foundation

struct RestaurantModel {
    let name: String
    let desc: String
    let image: String
}


struct RestModel: Decodable{
    let restaurant: RestaModel
}

struct RestaModel: Decodable{
    let coordinates: Coordinate
    let image: String?
    let menu: [RestaurantMenuModel]
    let name: String
    let yorumlar: String?
    let puan: PuanModel
    let category: String?
}

struct RestaurantMenuModel: Decodable{
    let id: String?
    let name: String
    let desc: String
    let cost: String
    let material: String?
    let isDeleted: Bool?
    var adet: Int?
    
    let image: String?
    
    enum CodingKeys: String, CodingKey{
        case id, name, image, adet
        case cost = "fiyat"
        case desc = "icerik"
        case material = "malzemeler"
        case isDeleted
    }
}

struct PuanModel: Decodable{
    let hiz: Double
    let lezzet: Double
    let servis: Double
}

struct Coordinate: Decodable{
    let latitude: Double
    let longitude: Double
}
