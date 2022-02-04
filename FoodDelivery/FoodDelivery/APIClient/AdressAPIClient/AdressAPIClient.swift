//
//  AdressAPIClient.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import RxSwift

public struct AdressAPIClient {
    public var updateAdress: (Adress) -> Single<Bool>
    
    public init(
        updateAdress: @escaping (Adress) -> Single<Bool>
    ) {
        self.updateAdress = updateAdress
    }
}
