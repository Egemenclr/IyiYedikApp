//
//  Live.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import RxSwift

public extension AdressAPIClient {
    static let live = Self(
       updateAdress: updateAdres(_:)
    )
}

private extension AdressAPIClient {
    static func updateAdres(_ adress: Adress) -> Single<Bool> {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        return Single<Bool>.create { single in
            guard let uuid = Auth.auth().currentUser?.uid else {
                single(.success(false))
                return Disposables.create()
            }
            
            ref.child("Users")
                .child(uuid)
                .child("adress")
                .updateChildValues(
                    ["title": adress.title,
                     "adressDesc": adress.adres,
                     "buildingNumber": adress.binaNo,
                     "flat": adress.kat,
                     "apartmentNumber": adress.daire,
                     "description": adress.tarif
                    ]
                )
            single(.success(true))
            return Disposables.create()
        }
    }
}
