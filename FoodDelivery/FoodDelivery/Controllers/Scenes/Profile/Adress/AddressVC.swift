//
//  AddressVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 22.08.2021.
//
import UIKit
import RxSwift
import RxCocoa

class AddressVC: UIViewController {
    let containerView = UIView()
    let adresBaslik = UITextField()
    let adres = UITextField()
    let bina  = UITextField()
    let kat   = UITextField()
    let daire = UITextField()
    let tarif = UITextField()
    let cancelButton = UIButton()
    let okButton     = UIButton()
    
    let bag = DisposeBag()
    let (adressUpdatedObserver, adressUpdatedEvent) = Driver<Adress>.pipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configure()
        
        let inputs = AdressViewModelInput(
            okButtonClicked: rx.okButtonTapped.asObservable(),
            title: rx.title.asObservable(),
            adres: rx.adres.asObservable(),
            bina: rx.bina.asObservable(),
            kat: rx.kat.asObservable(),
            daire: rx.daire.asObservable(),
            tarif: rx.tarif.asObservable()
        )
        let viewModel = AdressViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        
        bag.insert(
            outputs.updatedAdress
                .filter{ $0 }
                .do(onNext: { _ in
                    self.adressUpdatedObserver.on(
                        .next(Adress(
                            title:  self.adresBaslik.text ?? "",
                            adres:  self.adres.text ?? "",
                            binaNo: self.bina.text ?? "",
                            kat:    self.kat.text ?? "",
                            daire:  self.daire.text ?? "",
                            tarif:  self.tarif.text  ?? ""
                            ))
                    )
                })
                .drive()
        )
    }

    private func configure(){
        view.addSubview(containerView)
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor     = .systemBackground
        containerView.layer.cornerRadius  = 16
        containerView.layer.borderWidth   = 2
        containerView.layer.borderColor   = UIColor.white.cgColor
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        configureTitle()
        configureAdres()
        configureBina()
        configureTarif()
        configureButtons()
    }
    
    
    private func configureTitle(){
        containerView.addSubview(adresBaslik)
        adresBaslik.translatesAutoresizingMaskIntoConstraints = false
        
        adresBaslik.placeholder = "Başlık(Ev, İşyeri)"
        adresBaslik.borderStyle = .roundedRect
        
        let padding = CGFloat(10)
        NSLayoutConstraint.activate([
            adresBaslik.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            adresBaslik.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            adresBaslik.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            adresBaslik.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureAdres(){
        containerView.addSubview(adres)
        adres.translatesAutoresizingMaskIntoConstraints = false
        
        adres.layer.borderWidth  = 1
        adres.layer.borderColor  = UIColor.lightGray.cgColor
        adres.layer.cornerRadius = 8
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        adres.leftView = paddingView
        adres.leftViewMode = .always
        let padding = CGFloat(10)
        NSLayoutConstraint.activate([
            adres.topAnchor.constraint(equalTo: adresBaslik.bottomAnchor, constant: padding),
            adres.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            adres.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            adres.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureBina(){
        bina.placeholder  = "Bina No"
        bina.borderStyle  = .roundedRect
        
        kat.placeholder   = "Kat"
        kat.borderStyle   = .roundedRect
        
        daire.placeholder = "Daire No"
        daire.borderStyle = .roundedRect
        configureStackView()
        
    }
    
    private func configureStackView(){
        let stackView = UIStackView(arrangedSubviews: [bina, kat, daire])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: adres.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: adres.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: adres.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTarif(){
        containerView.addSubview(tarif)
        tarif.translatesAutoresizingMaskIntoConstraints = false
        
        tarif.placeholder = "Adres Tarifi"
        tarif.borderStyle = .roundedRect
        let padding = CGFloat(10)
        NSLayoutConstraint.activate([
            tarif.topAnchor.constraint(equalTo: bina.bottomAnchor, constant: padding),
            tarif.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            tarif.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            tarif.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func configureButtons(){
        containerView.addSubview(cancelButton)
        containerView.addSubview(okButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setTitle("İptal", for: .normal)
        cancelButton.backgroundColor = .systemPink
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius      = 10
        cancelButton.titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        
        okButton.setTitle("Kaydet", for: .normal)
        okButton.backgroundColor = .systemGreen
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius      = 10
        okButton.titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
        
        let padding = CGFloat(10)
        let buttonWidth = (300-4*padding)/2
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: tarif.bottomAnchor, constant: padding),
            cancelButton.leadingAnchor.constraint(equalTo: tarif.leadingAnchor, constant: padding),
            cancelButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            okButton.topAnchor.constraint(equalTo: tarif.bottomAnchor, constant: padding),
            okButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: padding),
            okButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            okButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension Reactive where Base == AddressVC {
    var okButtonTapped: ControlEvent<Void> {
        base.okButton.rx.tap
    }
    
    var cancelButtonTapped: ControlEvent<Void> {
        base.cancelButton.rx.tap
    }
    
    var title: ControlProperty<String> {
        base.adresBaslik.rx.text.orEmpty
    }
    
    var adres: ControlProperty<String> {
        base.adres.rx.text.orEmpty
    }

    var kat: ControlProperty<String> {
        base.kat.rx.text.orEmpty
    }
    
    var bina: ControlProperty<String> {
        base.bina.rx.text.orEmpty
    }
    
    var tarif: ControlProperty<String> {
        base.tarif.rx.text.orEmpty
    }

    var daire: ControlProperty<String> {
        base.daire.rx.text.orEmpty
    }
}
