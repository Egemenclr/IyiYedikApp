//
//  CategoriesModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 4.02.2022.
//

import Foundation

public struct RestaurantGenreModel: Decodable{
    public let imageUrlString: String
    public let name: String
    
    public init(name: String, image: String) {
        self.name = name
        self.imageUrlString = image
    }
    enum CodingKeys: String, CodingKey{
        case name
        case imageUrlString = "imageLink"
    }
}
