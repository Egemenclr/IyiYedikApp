//
//  LoginViewModel.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 9.12.2021.
//

import Foundation
import GoogleSignIn
import RxCocoa
import RxSwift

// MARK: - IO Model
struct LoginViewModelInput {
    let username: Observable<String>
    let password: Observable<String>
    let loginButtonTapped: Observable<Void>
    let googleButtonTapped: Observable<Void> = .never()
    let disposeBag: DisposeBag
}

struct LoginViewModelOutput {
    let showSiparisVC: Driver<Bool>
    let showError: Driver<String>
    let isLoginValid: Driver<Bool>
}

final class LoginViewModel {
    fileprivate let viewModelError = BehaviorRelay<String>(value: "")
    
    init(_ inputs: LoginViewModelInput) {
        
    }
    
    func outputs (_ inputs: LoginViewModelInput) -> LoginViewModelOutput {
        return LoginViewModelOutput(
            showSiparisVC: loginButtonTap(inputs, viewModelError),
            showError: viewModelError.asDriver(onErrorDriveWith: .never()),
            isLoginValid: validate(mail: inputs.username, password: inputs.password)
        )
    }
}

func loginButtonTap(
    _ inputs: LoginViewModelInput,
    _ error: BehaviorRelay<String>
) -> Driver<Bool> {
    inputs.loginButtonTapped
        .flatMap { _ -> Observable<Bool> in
            let successLogin = BehaviorRelay<Bool>(value: false)
            let name = BehaviorRelay<String>(value: "")
            let pass = BehaviorRelay<String>(value: "")
    
            name.accept(
                inputs
                    .username
                    .getValue(bag: inputs.disposeBag)
            )
            
            pass.accept(
                inputs
                    .password
                    .getValue(bag: inputs.disposeBag)
            )
            
            AuthManager.shared.logIn(name.value, pass.value) { success in
                if !success {
                    error.accept(ErrorConstants.invalidEmailAndPassword)
                }
                successLogin.accept(success)
            }
            return successLogin.asObservable()
        }
        .asDriver(onErrorDriveWith: .never())
}

func validate(
    mail: Observable<String>,
    password: Observable<String>
) -> Driver<Bool> {
    Observable
        .combineLatest(
            mail,
            password
        )
        .map{ username, password in
            return username.contains("@") && password.count > 3
        }
        .asDriver(onErrorDriveWith: .never())
}

extension Observable where Element == String {
    func getValue(bag: DisposeBag) -> String {
        let value = BehaviorRelay<String>(value: "")
        self
            .subscribe { element in
                value.accept(element)
            }.disposed(by: bag)
        return value.value
            
    }
}

private enum ErrorConstants {
    static let invalidEmailAndPassword = "Giriş bilgileriniz sistemimiz ile uyuşmuyor."
}
