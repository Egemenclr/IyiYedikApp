//
//  AdressViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 1.02.2022.
//

import Foundation
import RxSwift
import RxCocoa
import CloudKit

struct AdressViewModelInput {
    var adressAPI: AdressAPIClient = .live
    var okButtonClicked: Observable<Void> = .never()
    var title: Observable<String>
    var adres: Observable<String>
    var bina: Observable<String>
    var kat: Observable<String>
    var daire: Observable<String>
    var tarif: Observable<String>
}

struct AdressViewModelOutput {
    let updatedAdress: Driver<Bool>
}

final class AdressViewModel {
    let bag = DisposeBag()
    let adresBilgisi = BehaviorRelay<Adress>(value:
                                                Adress(title: "",
                                                       adres: "",
                                                       binaNo: "",
                                                       kat: "",
                                                       daire: "",
                                                       tarif: "")
    )
    
    init(_ inputs: AdressViewModelInput) {
        
        inputs.title
            .map { title -> Adress? in
                var copy = self.adresBilgisi.value
                copy.title = title
                return copy
            }
            .compactMap { $0 }
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
        inputs.adres
            .map { adres -> Adress in
                var copy = self.adresBilgisi.value
                copy.adres = adres
                return copy
            }
            .compactMap{$0}
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
        inputs.bina
            .map { bina -> Adress in
                var copy = self.adresBilgisi.value
                copy.binaNo = bina
                return copy
            }
            .compactMap{$0}
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
        inputs.kat
            .map { kat -> Adress in
                var copy = self.adresBilgisi.value
                copy.kat = kat
                return copy
            }
            .compactMap{$0}
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
        inputs.daire
            .map { daire -> Adress in
                var copy = self.adresBilgisi.value
                copy.daire = daire
                return copy
            }
            .compactMap{$0}
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
        inputs.tarif
            .map { tarif -> Adress in
                var copy = self.adresBilgisi.value
                copy.tarif = tarif
                return copy
            }
            .compactMap{$0}
            .bind(to: adresBilgisi)
            .disposed(by: bag)
        
    }
    
    func outputs(_ inputs: AdressViewModelInput) -> AdressViewModelOutput {
        return AdressViewModelOutput(
            updatedAdress: okButtonClicked(inputs,
                                           adress: self.adresBilgisi)
        )
    }
}

func okButtonClicked(
    _ inputs: AdressViewModelInput,
    adress: BehaviorRelay<Adress>
) -> Driver<Bool> {
    inputs.okButtonClicked
        .flatMapLatest({ _ -> Single<Bool> in
            return inputs.adressAPI.updateAdress(adress.value)
        })
        .asDriver(onErrorDriveWith: .never())
    
}
