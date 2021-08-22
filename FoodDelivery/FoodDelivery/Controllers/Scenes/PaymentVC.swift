//
//  PaymentVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 22.08.2021.
//

import UIKit

class PaymentVC: UIViewController {

    
    let cardNumber = CustomLoginTextFieldView()
    let expireDate = CustomLoginTextFieldView()
    let ccv = CustomLoginTextFieldView()
    let paymentButton = CustomButton()
    let textView = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let adressDesc = UITextView()
    var basketList: [RestaurantMenuModel] = []
    
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
        
        NetworkManager.shared.getFirebaseUser(entityName: "Users", child: AuthManager.shared.getUUID(), type: User.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let user):
                
                self.cardNumber.textField.text = user.cardNumber
                self.expireDate.textField.text = user.expireDate
                self.ccv.textField.text = user.CCV
                
                self.adressDesc.text = "\(user.adress.adressDesc) Bina No:\(user.adress.buildingNumber) Kat:\(user.adress.flat) İç Kapı:\(user.adress.apartmentNumber) - \(user.adress.description)"
                
            case .failure( _):
                break
            }
        }
    }
    
    private func configureUI(){

        configureCardNumber()
        configureExpireField()
        configureTextField()
        configureAdressDesc()
        configurebutton()
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
        LoadingView.shared.startLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            LoadingView.shared.hideLoading()
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
            NetworkManager.shared.deleteFood(index: index)
        }
        self.basketList.removeAll()
        
        guard let tabBar = self.tabBarController else { return }
        tabBar.selectedIndex = 0
    }
}
