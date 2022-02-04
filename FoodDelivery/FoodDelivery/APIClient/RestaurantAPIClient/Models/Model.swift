//
//  Model.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation

public struct TestModel: Decodable {
    let restaurants: [RestModel]
    
    enum CodingKeys: String, CodingKey {
        case restaurants = "Restaurants"
    }
}

public struct RestModel: Decodable, Equatable{
    public let restaurant: RestaModel
}

public struct RestaModel: Decodable, Equatable{
    public let coordinates: Coordinate
    public let image: String?
    public let menu: [RestaurantMenuModel]
    public let name: String
    public let yorumlar: String?
    public let puan: PuanModel
    public let category: String?
}

public struct RestaurantMenuModel: Decodable, Equatable{
    public let id: String?
    public let name: String
    public let desc: String
    public let cost: String
    public let material: String?
    public let isDeleted: Bool?
    public var adet: Int?
    
    public let image: String?
    
    enum CodingKeys: String, CodingKey{
        case id, name, image, adet
        case cost = "fiyat"
        case desc = "icerik"
        case material = "malzemeler"
        case isDeleted
    }
}

public struct PuanModel: Decodable, Equatable{
    public let hiz: Double
    public let lezzet: Double
    public let servis: Double
}

public struct Coordinate: Decodable, Equatable{
    public let latitude: Double
    public let longitude: Double
}
