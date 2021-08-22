//
//  RestaurantGenreModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 7.08.2021.
//

import UIKit

struct RestaurantGenreModel: Decodable{
    let imageUrlString: String
    let name: String
    
    init(name: String, image: String) {
        self.name = name
        self.imageUrlString = image
    }
    enum CodingKeys: String, CodingKey{
        case name
        case imageUrlString = "imageLink"
    }
}

