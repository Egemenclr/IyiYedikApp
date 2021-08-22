//
//  CategoriesModel.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 17.08.2021.
//

import Foundation

struct CategoriesModel: Decodable{
    let name: String
    let imageUrlString: String
    
    init(name: String, image: String) {
        self.name = name
        self.imageUrlString = image
    }
    
    enum CodingKeys: String, CodingKey{
        case name
        case imageUrlString = "imageLink"
    }
}
