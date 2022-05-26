//
//  OtherInteractor.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 10.02.2022.
//

import UIKit
import RxSwift

// know presenter, entity
// protocol

final class OtherInteractor: OtherInteracting {
  var presenter: OtherPresenter?
  
  
  func getRowNames(
    
  ) -> Single<[RowStruct]> {
    Single.create { single in
      single(
        .success(
          [
            RowStruct(name: "Bilgilerim"),
            RowStruct(name: "Önceki Siparişlerim"),
            RowStruct(name: "Favorilerim"),
            RowStruct(name: "Adreslerim"),
            RowStruct(name: "Kredi Kartlarım"),
            RowStruct(name: "Kampüs")
          ]
        )
      )
      return Disposables.create()
    }
  }
}
