//
//  ProfileVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 1.08.2021.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    let signOutButton = CustomButton()
    let name = CustomLoginTextFieldView()
    let surname = CustomLoginTextFieldView()
    let cardNumber = CustomLoginTextFieldView()
    let expireDate = CustomLoginTextFieldView()
    let ccv = CustomLoginTextFieldView()
    
    let addressTitle = CustomLoginTextFieldView()
    let adressDesc = UITextView()
    
    
    let updateAdress = CustomButton()
    let updateInfo = CustomButton()
    
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
    
    private func setUI(){
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        NetworkManager.shared.getFirebaseUser(entityName: "Users", child: uuid, type: User.self) { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let user):
                self.name.textField.text = user.name
                self.surname.textField.text = user.surname
                self.cardNumber.textField.text = user.cardNumber
                self.expireDate.textField.text = user.expireDate
                self.ccv.textField.text = user.CCV
                self.addressTitle.textField.text = user.adress.title
                self.adressDesc.text = "\(user.adress.adressDesc) Bina No:\(user.adress.buildingNumber) Kat:\(user.adress.flat) İç Kapı:\(user.adress.apartmentNumber) - \(user.adress.description)"
                
            case .failure( _):
                break
            }
        }
    }
    
    private func configureUI(){
       
        configureName()
        configureSurname()
        configureCardNumber()
        configureExpireField()
        configureAddressTitle()
        configureAdressDesc()
        configureupdateUserInfo()
        configureAddAdressButton()
        configurebutton()
    }
    
    
    private func configureName(){
        view.addSubview(name)
        name.headerText.text = "Ad"
        name.textField.text = ""
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            name.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureSurname(){
        view.addSubview(surname)
        surname.headerText.text = "Soyad"
        surname.textField.text = ""
        NSLayoutConstraint.activate([
            surname.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            surname.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            surname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            surname.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureCardNumber(){
        view.addSubview(cardNumber)
        cardNumber.headerText.text = "Kart Numarası"
        cardNumber.textField.placeholder = "**** **** **** ****"
        cardNumber.textField.keyboardType = .numberPad
        NSLayoutConstraint.activate([
            cardNumber.topAnchor.constraint(equalTo: surname.bottomAnchor, constant: 10),
            cardNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cardNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cardNumber.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureExpireField(){
        expireDate.headerText.text = "SKT"
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
    
    private func configureAddressTitle(){
        view.addSubview(addressTitle)
        addressTitle.headerText.text = "Başlık (Ev, İşyeri)"
        addressTitle.textField.placeholder = "Ev iş"
        
        NSLayoutConstraint.activate([
            addressTitle.topAnchor.constraint(equalTo: expireDate.bottomAnchor, constant: 20),
            addressTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addressTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addressTitle.heightAnchor.constraint(equalToConstant: 80)
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
            adressDesc.topAnchor.constraint(equalTo: addressTitle.bottomAnchor),
            adressDesc.leadingAnchor.constraint(equalTo: addressTitle.leadingAnchor, constant: 10),
            adressDesc.trailingAnchor.constraint(equalTo: addressTitle.trailingAnchor, constant: -10),
            adressDesc.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    private func configureAddAdressButton(){
        view.addSubview(updateAdress)
        
        updateAdress.set(text: "Adres Güncelle", color: .white)
        updateAdress.setTitleColor(.black, for: .normal)
        updateAdress.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        updateAdress.addTarget(self, action: #selector(openUpdateAdress), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            updateAdress.topAnchor.constraint(equalTo: adressDesc.bottomAnchor, constant: 10),
            updateAdress.trailingAnchor.constraint(equalTo: adressDesc.trailingAnchor,constant: -10),
            updateAdress.widthAnchor.constraint(equalToConstant: 100),
            updateAdress.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureupdateUserInfo(){
        view.addSubview(updateInfo)
        
        updateInfo.set(text: "Bilgilerimi Güncelle", color: .white)
        updateInfo.setTitleColor(.black, for: .normal)
        updateInfo.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        updateInfo.addTarget(self, action: #selector(updateUserInfo), for: .touchUpInside)
        NSLayoutConstraint.activate([
            updateInfo.topAnchor.constraint(equalTo: adressDesc.bottomAnchor, constant: 10),
            updateInfo.leadingAnchor.constraint(equalTo: adressDesc.leadingAnchor, constant: 10),
            updateInfo.widthAnchor.constraint(equalToConstant: 150),
            updateInfo.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configurebutton(){
        view.addSubview(signOutButton)
        signOutButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        signOutButton.setTitle("Çıkış yap", for: .normal)
        signOutButton.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signOutButton.leadingAnchor.constraint(equalTo: adressDesc.leadingAnchor, constant: 10),
            signOutButton.trailingAnchor.constraint(equalTo: adressDesc.trailingAnchor,constant: -10),
            signOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func buttonClicked(){
        AuthManager.shared.logOut { [weak self] (success) in
            guard let self = self else { return }
            if success{
                let loginVC = LoginVC()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
    
    
    @objc func openUpdateAdress(){
         let alertVC = AddressVC()
        alertVC.updateDelegate = self
         alertVC.modalTransitionStyle = .crossDissolve
         alertVC.modalPresentationStyle = .overFullScreen
         self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func updateUserInfo(){
        guard let name = name.textField.text,
              let surname = surname.textField.text,
              let cardNumber = cardNumber.textField.text,
              let expireDate = expireDate.textField.text,
              let ccv = ccv.textField.text else { return }
        
        NetworkManager.shared.updateUser(name: name, surname: surname, cardNumber: cardNumber, expireDate: expireDate, CCV: ccv)
        guard let alert = returnCustomAlertOnMainThread(title: "Güncelleme Başarılı ✅",
                                                        message: "Bilgilerin güncel olduğunu düşünüyorsan gönül rahatlığıyla sipariş verebilirsin.",
                                                        buttonTitle: "Tamam") else { return }
        alert.actionButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    
        self.present(alert, animated: true)
    }
    
    @objc func showAlert(){
        self.dismiss(animated: true)
    }
}

extension ProfileVC: UpdateUIProtocol{
    func update() {
        self.setUI()
    }
    
    
}
