//
//  UserInfoView.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 11.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoView: UIView {
    private let contentView = UIView()
    let signOutButton = CustomButton()
    let name = CustomLoginTextFieldView()
    let surname = CustomLoginTextFieldView()
    let cardNumber = CustomLoginTextFieldView()
    let expireDate = CustomLoginTextFieldView()
    let ccv = CustomLoginTextFieldView()

    let addressTitle = CustomLoginTextFieldView()
    let adressDesc = UITextView()
    let stackViewEqually = UIStackView()
    var subViews = [UIView]()


    let updateAdress = CustomButton()
    let updateInfo = CustomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        configure()
    }
    
    private func configure() {
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = .systemBackground
        
        configureName()
        configureSurname()
        configureCardNumber()
        configureExpireField()
        configureAddressTitle()
        configureAdressDesc()
        configureAddAdressButton()
        configureStackView()
        configureButton()
    }
    
    private func configureStackView() {
        contentView.addSubview(stackViewEqually)
        stackViewEqually.spacing = 5
        stackViewEqually.axis = .vertical
        stackViewEqually.distribution = .fill
        stackViewEqually.backgroundColor = .systemBackground
        stackViewEqually.frame = contentView.bounds
        
         stackViewEqually.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             stackViewEqually.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
             stackViewEqually.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
             stackViewEqually.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30)

         ])
        subViews.forEach { view in
            stackViewEqually.addArrangedSubview(view)
        }
    }
    
    private func configureName() {
        name.headerText.text = HeaderConstants.name
        name.textField.text = ""
        name.heightAnchor.constraint(equalToConstant: 70).isActive = true
        subViews.append(name)
    }
    
    private func configureSurname() {
        surname.headerText.text = HeaderConstants.surname
        surname.textField.text = ""
        surname.heightAnchor.constraint(equalToConstant: 70).isActive = true
        subViews.append(surname)
    }
    
    private func configureCardNumber() {
        cardNumber.headerText.text = HeaderConstants.cardNumber
        cardNumber.textField.placeholder = "**** **** **** ****"
        cardNumber.textField.keyboardType = .numberPad
        cardNumber.heightAnchor.constraint(equalToConstant: 70).isActive = true
        subViews.append(cardNumber)
    }
    
    private func configureExpireField() {
        expireDate.headerText.text = HeaderConstants.skt
        expireDate.textField.placeholder = "12/22"
        expireDate.textField.textAlignment = .center
        expireDate.setContentHuggingPriority(.required, for: .horizontal)
        expireDate.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        ccv.headerText.text = HeaderConstants.ccv
        ccv.textField.placeholder = "000"
        ccv.textField.textAlignment = .center
        ccv.textField.isSecureTextEntry = true
        ccv.textField.keyboardType = .numberPad
        ccv.setContentHuggingPriority(.required, for: .horizontal)
        ccv.setContentCompressionResistancePriority(.required, for: .horizontal)
        
                
        let subStackView = UIStackView(arrangedSubviews: [expireDate, ccv])
        subStackView.alignment = .fill
        subStackView.spacing = 5
        subStackView.axis = .horizontal
        subStackView.distribution = .fillEqually
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subStackView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        subViews.append(subStackView)
    }
    
    private func configureAddressTitle() {
        addressTitle.headerText.text = HeaderConstants.adressTitle
        addressTitle.textField.placeholder = "Ev iş"
        addressTitle.heightAnchor.constraint(equalToConstant: 70).isActive = true
        subViews.append(addressTitle)
    }
    
    private func configureAdressDesc() {
        adressDesc.text = HeaderConstants.adressDesc
        adressDesc.font = Fonts.helvetica?.withSize(16)
        adressDesc.textColor = .black
        adressDesc.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        adressDesc.translatesAutoresizingMaskIntoConstraints = false
        adressDesc.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            adressDesc.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        subViews.append(adressDesc)
    }
    
    private func configureAddAdressButton() {
        updateAdress.set(text: ButtonConstants.updateAdress, color: .white)
        updateAdress.contentMode = .left
        updateAdress.setTitleColor(.black, for: .normal)
        updateAdress.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        
        updateInfo.set(text: ButtonConstants.updateInfo, color: .white)
        updateInfo.contentMode = .right
        updateInfo.setTitleColor(.black, for: .normal)
        updateInfo.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        
        let subStackView = UIStackView(arrangedSubviews: [updateAdress, updateInfo])
        subStackView.axis = .horizontal
        subStackView.distribution = .equalCentering
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        subViews.append(subStackView)
    }
    
    private func configureButton() {
        signOutButton.setTitle(ButtonConstants.logout, for: .normal)
        signOutButton.backgroundColor = .systemPink
        contentView.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: stackViewEqually.safeAreaLayoutGuide.bottomAnchor),
            signOutButton.leadingAnchor.constraint(equalTo: stackViewEqually.leadingAnchor, constant: 10),
            signOutButton.trailingAnchor.constraint(equalTo: stackViewEqually.trailingAnchor, constant: -10),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - Rx + ObserveUI
extension Reactive where Base == UserInfoView {
    var name: ControlProperty<String> {
        base.name.textField.rx.text.orEmpty
    }
    
    var surname: ControlProperty<String> {
        base.surname.textField.rx.text.orEmpty
    }
    
    var expireDateObservable: Observable<String> {
        base.expireDate.textField.rx.text.orEmpty.asObservable()
    }
    
    var cardNumber: ControlProperty<String> {
        base.cardNumber.textField.rx.text.orEmpty
    }
    
    var ccv: ControlProperty<String> {
        base.ccv.textField.rx.text.orEmpty
    }

    var updateAdressButton: ControlEvent<Void> {
        base.updateAdress.rx.tap
    }
    
    var updateInfoButton: ControlEvent<Void> {
        base.updateInfo.rx.tap
    }
    
    var logOutButton: ControlEvent<Void> {
        base.signOutButton.rx.tap
    }
}


// MARK: - Populate
struct BinderStruct {
    let user: User
    let message: String
    
    init(_ user: User,
         _ message: String){
        self.user = user
        self.message = message
    }
}

extension Reactive where Base == UserInfoView {
    var populate: Binder<BinderStruct> {
        Binder(base) { target, datasource in
            target.name.textField.text = datasource.user.name
            target.surname.textField.text = datasource.user.surname
            target.cardNumber.textField.text = datasource.user.cardNumber
            target.expireDate.textField.text  = datasource.user.expireDate
            target.ccv.textField.text = datasource.user.CCV
            target.addressTitle.textField.text = datasource.user.adress.title
            target.adressDesc.text = "\(datasource.user.adress.adressDesc) Bina No:\(datasource.user.adress.buildingNumber) Kat:\(datasource.user.adress.flat) İç Kapı:\(datasource.user.adress.apartmentNumber) - \(datasource.user.adress.description)"
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
}

