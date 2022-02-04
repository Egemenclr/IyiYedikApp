//
//  ProfileVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 1.08.2021.
//

import UIKit
import RxSwift

class ProfileVC: UIViewController {
    fileprivate let bag = DisposeBag()
    fileprivate let userInfoView = UserInfoView()
    
    private let scrollView = UIScrollView()
    private let activityIndicator = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        configureScrollViewAndInfoView()
        
        let loginValidation = userInfoView.name.textField
            .rx.text
            .map({!$0!.isEmpty})
            .share(replay: 1)
        
        let nameValid = userInfoView.name.textField.rx.text
            .map{ $0?.count ?? 0 < 21 }
            .share(replay: 1)
        
        let combineValid = Observable.combineLatest(loginValidation, nameValid) { $0 && $1 }
            .share(replay: 1)
        
        combineValid
            .bind(to: userInfoView.updateInfo.rx.isEnabled)
            .disposed(by: bag)
        
        let inputs = ProfileViewModelInput(
            name: userInfoView.rx.name.asObservable(),
            surname: userInfoView.rx.surname.asObservable(),
            cardNumber: userInfoView.rx.cardNumber.asObservable(),
            expireDate: userInfoView.rx.expireDateObservable,
            ccv: userInfoView.rx.ccv.asObservable(),
            updateAdressbuttonTapped: userInfoView.rx.updateAdressButton.asObservable(),
            updateInfoButtonTapped: userInfoView.rx.updateInfoButton.asObservable(),
            logOutButtonTapped: userInfoView.rx.logOutButton.asObservable(),
            bag: bag
        )
        
        let profileViewModel = ProfileViewModel(inputs)
        let viewModelOutputs = profileViewModel.outputs(inputs: inputs)
        
        viewModelOutputs.user
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { user in
                guard let user = user else { return }
                self.userInfoView.rx.populate.onNext(BinderStruct(user, "egemen"))
            })
            .disposed(by: bag)
        
        viewModelOutputs
            .popupMessageOutput
            .skip(1)
            .drive(rx.displayPopup)
            .disposed(by: bag)
        
        viewModelOutputs
            .isLoading
            .distinctUntilChanged()
            .filter{!$0}
            .drive(activityIndicator.rx.hideAnimate)
            .disposed(by: bag)
        
        viewModelOutputs
            .showAdressUpdateView
            .filter{ $0 }
            .drive(rx.showUpdateAdressView)
            .disposed(by: bag)
        
        viewModelOutputs
            .showLoginVC
            .distinctUntilChanged()
            .filter{$0}
            .drive(rx.logOut)
            .disposed(by: bag)
        
        
    }
    
    private func configureScrollViewAndInfoView() {
        lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 75.0)
        
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentViewSize
        
        userInfoView.frame.size = contentViewSize
        userInfoView.setUI()
        
        view.addSubview(scrollView)
        scrollView.addSubview(userInfoView)
        
    }
}
// MARK: - Rx + ProfileVC
extension Reactive where Base == ProfileVC {
    var displayPopup: Binder<Void> {
        Binder(base) { target, message in
            target.showAlert(
                title: ButtonConstants.successUpdateTitle,
                message: ButtonConstants.successUpdateMessage,
                positiveButtonTitle: ButtonConstants.okButtonTitle,
                negativeButtonTitle: ButtonConstants.cancelButtonTitle
            )
                .asObservable()
                .subscribe()
                .disposed(by: base.bag)
        }
    }
}

// MARK: - Rx + ProfileVC
extension Reactive where Base == ProfileVC {
    var showUpdateAdressView: Binder<Bool> {
        Binder(base) { target, shouldI in
            if shouldI {
                let alertVC = AddressVC()
                alertVC.adressUpdatedEvent
                    .asObservable()
                    .subscribe { adres in
                        target.userInfoView.addressTitle.textField.text = adres.element?.title
                        target.userInfoView.adressDesc.text = adres.element?.toString()
                        target.dismiss(animated: true)
                    }
                    .disposed(by: target.bag)
                        
//                alertVC.cancelButton.rx.tap
//                    .subscribe(onNext: {
//                        alertVC.cancelButtonClicked()
//                    }).disposed(by: target.bag)
                
                alertVC.modalTransitionStyle = .crossDissolve
                alertVC.modalPresentationStyle = .overFullScreen
                target.self.present(alertVC, animated: true)
            }
        }
    }
    
    var logOut: Binder<Bool> {
        Binder(base) { target, shouldI in
            if shouldI {
                AuthManager.shared.logOut { [weak target] (success) in
                    guard let target = target else { return }
                    if success{
                        let loginVC = LoginVC()
                        loginVC.modalPresentationStyle = .fullScreen
                        target.present(loginVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Enums
private enum HeaderConstants {
    static let name = "Ad"
    static let surname = "Soyad"
    static let cardNumber = "Kart Numarası"
    static let skt = "SKT"
    static let ccv = "CCV"
    static let adressTitle = "Başlık (Ev, İşyeri)"
    static let adressDesc = "Adres"
}

private enum ButtonConstants {
    static let updateAdress = "Adres Güncelle"
    static let updateInfo = "Bilgilerimi Güncelle"
    static let logout = "Çıkış yap"
    static let successUpdateTitle = "Güncelleme Başarılı ✅"
    static let successUpdateMessage = "Bilgilerin güncel olduğunu düşünüyorsan gönül rahatlığıyla sipariş verebilirsin."
    static let okButtonTitle = "Tamam"
    static let cancelButtonTitle = "İptal"
}
