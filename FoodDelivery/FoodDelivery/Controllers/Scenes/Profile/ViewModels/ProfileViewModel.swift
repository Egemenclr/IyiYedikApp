//
//  ProfileViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 11.11.2021.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit
import Common

// MARK: - IO Model
struct ProfileViewModelInput {
    var name: Observable<String>
    var surname: Observable<String>
    var cardNumber: Observable<String>
    var expireDate: Observable<String>
    var ccv: Observable<String>
    var updateAdressbuttonTapped: Observable<Void>
    var updateInfoButtonTapped: Observable<Void>
    var logOutButtonTapped: Observable<Void>
    var bag: DisposeBag
}

struct ProfileViewModelOutput {
    let user: BehaviorRelay<User?>
    let popupMessageOutput: Driver<Void>
    let isLoading: Driver<Bool>
    let showAdressUpdateView: Driver<Bool>
    let showLoginVC: Driver<Bool>
}

final class ProfileViewModel {
    var bag: DisposeBag
    var currentUser = BehaviorRelay<User>(value: User.empty)
    var updateAdresButtonTapped: Observable<Void> = .never()

    
    //Outputs
    let popupMessageDriver = BehaviorSubject<Void>(value: ())
    let shouldLoading = BehaviorSubject<Bool>(value: false)
    let shouldAdressUpdateViewShow = BehaviorSubject<Bool>(value: false)
    let shouldLogout = BehaviorSubject<Bool>(value: false)
    
    var inputs: ProfileViewModelInput
    
    init(_ inputs: ProfileViewModelInput) {
        self.bag = inputs.bag
        self.inputs = inputs
        
        inputs.name
            .map { name -> User? in
                var copy = self.currentUser.value
                copy.name = name
                return copy
            }
            .compactMap { $0 }
            .bind(to: currentUser)
            .disposed(by: bag)
        
        inputs.surname
            .map { surname -> User? in
                var copy = self.currentUser.value
                copy.surname = surname
                return copy
            }
            .compactMap { $0 }
            .bind(to: currentUser)
            .disposed(by: bag)
        
        inputs.cardNumber
            .map { cardNumber -> User? in
                var copy = self.currentUser.value
                copy.cardNumber = cardNumber
                return copy
            }
            .compactMap{ $0 }
            .bind(to: currentUser)
            .disposed(by: bag)
        
        inputs.expireDate
            .map { expireDate -> User? in
                var copy = self.currentUser.value
                copy.expireDate = expireDate
                return copy
            }
            .compactMap { $0 }
            .bind(to: currentUser)
            .disposed(by: bag)
       
        inputs.ccv
            .map { ccv -> User? in
                var copy = self.currentUser.value
                copy.CCV = ccv
                return copy
            }
            .compactMap { $0 }
            .bind(to: currentUser)
            .disposed(by: bag)
        
        inputs.updateAdressbuttonTapped.subscribe { damn in
            self.shouldAdressUpdateViewShow.on(.next(true))
        } onError: { err in
            print("updateAdressbuttonTapped error: \(err)")
        }.disposed(by: bag)
        
        
        inputs.updateInfoButtonTapped
            .subscribe { _ in
                updateUserInfo(self.currentUser.value)
                self.popupMessageDriver.on(.next(()))
            }
            .disposed(by: bag)
        
        inputs.logOutButtonTapped
            .subscribe { _ in
                print("hop")
                self.shouldLogout.on(.next(true))
            }
            .disposed(by: bag)
        
    }
    
    func outputs(inputs: ProfileViewModelInput) -> ProfileViewModelOutput {
        return ProfileViewModelOutput(
            user: getUserInfo(shouldLoading, inputs.bag),
            popupMessageOutput: self.popupMessageDriver.asDriver(onErrorJustReturn: ()),
            isLoading: self.shouldLoading.asDriver(onErrorJustReturn: false),
            showAdressUpdateView: self.shouldAdressUpdateViewShow.asDriver(onErrorJustReturn: false),
            showLoginVC: self.shouldLogout.asDriver(onErrorJustReturn: false)
        )
    }
}

private func handleButtonTap () {
    
}

private func getUserInfo (
    _ indicator: BehaviorSubject<Bool>,
    _ bag: DisposeBag)
-> BehaviorRelay<User?> {
    guard let uuid = Auth.auth().currentUser?.uid else { return BehaviorRelay<User?>(value: User.empty) }
    let element = BehaviorRelay<User?>(value: User.empty)
    
    NetworkLayer.getFirebaseUser(entityName: "Users",
                                          child: uuid,
                                          type: User.self)
        .subscribe { single in
            switch single {
            case .success(let user):
                let adresModel = AddressModel(title: user.adress.title, adressDesc: user.adress.adressDesc, buildingNumber: user.adress.buildingNumber, flat: user.adress.flat, apartmentNumber: user.adress.apartmentNumber, description: user.adress.description)
                let user = User(name: user.name, surname: user.surname, cardNumber:  user.cardNumber, expireDate: user.expireDate, CCV: user.CCV, adress: adresModel)
                element.accept(user)
                indicator.on( .next(true) )
            case .failure(let error):
                print("ProfileViewModel getUserInfo func Error: \(error)")
                element.accept(.empty)
            }
        }
        .disposed(by: bag)
    return element
}
 
private func updateUserInfo(_ user: User) {
    let name = user.name
    let surname = user.surname
    let cardNumber = user.cardNumber
    let expireDate = user.expireDate
    let ccv = user.CCV
    
    NetworkLayer.updateUser(name: name, surname: surname, cardNumber: cardNumber, expireDate: expireDate, CCV: ccv)
}
