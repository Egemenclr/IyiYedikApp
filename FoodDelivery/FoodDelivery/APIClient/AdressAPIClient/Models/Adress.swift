//
//  Adress.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import RxSwift

public struct Adress {
    var title: String
    var adres: String
    var binaNo: String
    var kat: String
    var daire: String
    var tarif: String
}

extension Adress {
    func toString() -> String {
        "\(self.title) Bina No:\(self.binaNo) Kat:\(self.kat) İç Kapı:\(self.daire) - \(self.tarif)"
    }
}
