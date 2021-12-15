//
//  PaymentVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 22.08.2021.
//

import UIKit
import RxSwift
import Common

class PaymentVC: UIViewController {
    private let bag = DisposeBag()
    
    // MARK: Constraints
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private let cardNumber = CustomLoginTextFieldView()
    private let expireDate = CustomLoginTextFieldView()
    private let ccv = CustomLoginTextFieldView()
    private let paymentButton = CustomButton()
    private let textView = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    private let adressDesc = UITextView()
    private var basketList: [RestaurantMenuModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        configureUI()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        
    }
    
    init(list: [RestaurantMenuModel]){
        super.init(nibName: nil, bundle: nil)
        self.basketList = list
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        
        NetworkLayer.getFirebaseUser(entityName: "Users",
                                              child: AuthManager.shared.getUUID(),
                                              type: User.self).subscribe{ [weak self] single in
            guard let self = self else { return }
            switch single{
            case .success(let user):
                self.cardNumber.textField.text = user.cardNumber
                self.expireDate.textField.text = user.expireDate
                self.ccv.textField.text = user.CCV
                self.adressDesc.text = "\(user.adress.adressDesc) Bina No:\(user.adress.buildingNumber) Kat:\(user.adress.flat) İç Kapı:\(user.adress.apartmentNumber) - \(user.adress.description)"
                
            case .failure( _):
                break
            }
        }.disposed(by: bag)
    }
    
    private func configureUI(){

        configureCardNumber()
        configureExpireField()
        configureTextField()
        configureAdressDesc()
        configurebutton()
    }
    
    private func layoutTrait(traitCollection: UITraitCollection) {
        if (!sharedConstraints[0].isActive) {
           // activating shared constraints
           NSLayoutConstraint.activate(sharedConstraints)
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            // activating compact constraints
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            // activating regular constraints
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    
    private func configureCardNumber(){
        view.addSubview(cardNumber)
        cardNumber.headerText.text = "Kart Numarası"
        cardNumber.textField.placeholder = "**** **** **** ****"
        cardNumber.textField.keyboardType = .numberPad
        NSLayoutConstraint.activate([
            cardNumber.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cardNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cardNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cardNumber.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureExpireField(){
        expireDate.headerText.text = "Expire Date"
        expireDate.textField.placeholder = "12/22"
        expireDate.textField.textAlignment = .center
        
        ccv.headerText.text = "CCV"
        ccv.textField.placeholder = "000"
        ccv.textField.textAlignment = .center
        ccv.textField.isSecureTextEntry = true
        ccv.textField.keyboardType = .numberPad
        
        view.addSubview(expireDate)
        view.addSubview(ccv)
        NSLayoutConstraint.activate([
            expireDate.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 10),
            expireDate.leadingAnchor.constraint(equalTo: cardNumber.leadingAnchor),
            expireDate.widthAnchor.constraint(equalToConstant: 100),
            expireDate.heightAnchor.constraint(equalToConstant: 70),
            
            ccv.topAnchor.constraint(equalTo: cardNumber.bottomAnchor, constant: 10),
            ccv.leadingAnchor.constraint(equalTo: expireDate.trailingAnchor),
            ccv.widthAnchor.constraint(equalToConstant: 100),
            ccv.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func configureTextField(){
        view.addSubview(textView)
        textView.text = "Teslimat Adresi"
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: expireDate.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: expireDate.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureAdressDesc(){
        view.addSubview(adressDesc)
        
        adressDesc.text = "Adres"
        adressDesc.font = Fonts.helvetica?.withSize(16)
        adressDesc.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        adressDesc.translatesAutoresizingMaskIntoConstraints = false
        adressDesc.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            adressDesc.topAnchor.constraint(equalTo: textView.bottomAnchor),
            adressDesc.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            adressDesc.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -10),
            adressDesc.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    private func configurebutton(){
        view.addSubview(paymentButton)
        paymentButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        paymentButton.setTitle("Ödemeyi Tamamla", for: .normal)
        paymentButton.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            paymentButton.leadingAnchor.constraint(equalTo: adressDesc.leadingAnchor, constant: 10),
            paymentButton.trailingAnchor.constraint(equalTo: adressDesc.trailingAnchor,constant: -10),
            paymentButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func buttonClicked(){
        guard let alert = returnCustomAlertOnMainThread(title: "Sipariş vermek üzeresin",
                                                        message: "Bilgilerin doğruluğunu kontrol ettiysen sipariş verebilirsin. Bilgilerini profilinden düzenleyebilirsin.",
                                                        buttonTitle: "Evet") else { return }
        alert.actionButton.addTarget(self, action: #selector(completePayment), for: .touchUpInside)
        alert.cancelButton.addTarget(self, action: #selector(cancelPayment), for: .touchUpInside)
        self.present(alert, animated: true)
    }
    
    @objc func completePayment(){
        self.dismiss(animated: true)
        //LoadingView.shared.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //LoadingView.shared.hideLoading()
            let toastMessage = self.makeAlert(title: "Ödeme Başarılı ✅", message: "Afiyet olsun🌭🍕🍔")
            self.present(toastMessage, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.dismiss(animated: true)
                    self.deleteBasketItemsAndNavigate()
                }
            }
        }
        
    }
    
    @objc func cancelPayment(){
        self.dismiss(animated: true)
    }
    
    private func deleteBasketItemsAndNavigate(){
        for item in self.basketList{
            guard let index = Int(item.id!) else { return }
            NetworkLayer.deleteFood(index: index)
            
        }
        self.basketList.removeAll()
        
        guard let tabBar = self.tabBarController else { return }
        tabBar.selectedIndex = 0
    }
}
