//
//  FoodDeteilVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 12.08.2021.
//

import UIKit
import Firebase
import RxSwift
import Common

class FoodDetailVC: UIViewController {
    
    private let foodName   = CustomBodyLabel(textAlignment: .left)
    private let foodDetil  = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    private let divider    = DividerView()
    private let stepper    = UIStepper(frame: CGRect(x: 0, y: 0, width: 30, height: 50))
    private let countLabel = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    private let costLabel  = CustomTitleLabel(textAlignment: .right, fontSize: 14)
    private let addBasket  = CustomButton(backgroundColor: .systemGreen, title: "Sepete Ekle")
    let disposeBag = DisposeBag()
    
    private var detail: RestaurantMenuModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        configureUI()
        title = "Ürün Detayı"
    }
    
    func setUI(detail: RestaurantMenuModel){
        self.detail = detail
    }
    
    private func configureUI(){
        configureRestaurantName()
        configureFoodDetail()
        configureDivider()
        configureStepper()
        configureCountLabel()
        configureCostLabel()
        configureAddBasket()
        
    }

    
    private func configureRestaurantName(){
        view.addSubview(foodName)
        
        foodName.text = detail?.name
        foodName.textColor = .label
        NSLayoutConstraint.activate([
            foodName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            foodName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            foodName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            foodName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureFoodDetail(){
        view.addSubview(foodDetil)
        foodDetil.numberOfLines = 3
        foodDetil.textColor = .secondaryLabel
        foodDetil.lineBreakMode = .byTruncatingTail
       
        foodDetil.text = detail?.desc
        NSLayoutConstraint.activate([
            foodDetil.topAnchor.constraint(equalTo: foodName.bottomAnchor, constant: 5),
            foodDetil.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            foodDetil.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            foodDetil.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureDivider(){
        view.addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: foodDetil.bottomAnchor, constant: 5),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func configureStepper(){
        view.addSubview(stepper)
        
        stepper.autorepeat = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        NSLayoutConstraint.activate([
            stepper.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            stepper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
        ])
    }
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        countLabel.text = "\(Int(stepper.value)) adet"
        guard let cost = Double(self.detail!.cost) else { return }
        costLabel.text =  "\(stepper.value * cost) ₺"
        
    }
    
    private func configureCountLabel(){
        view.addSubview(countLabel)
        countLabel.text = "\(Int(stepper.value)) adet"
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: stepper.topAnchor, constant: 5),
            countLabel.leadingAnchor.constraint(equalTo: stepper.trailingAnchor, constant: 5),
            countLabel.widthAnchor.constraint(equalToConstant: 50),
            countLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureCostLabel(){
        view.addSubview(costLabel)
        guard let cost = detail?.cost else { return }
        costLabel.text =  "\(cost) ₺"
        NSLayoutConstraint.activate([
            costLabel.topAnchor.constraint(equalTo: countLabel.topAnchor),
            costLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            costLabel.widthAnchor.constraint(equalToConstant: 100),
            costLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureAddBasket(){
        view.addSubview(addBasket)
        addBasket.addTarget(self, action: #selector(addBasketButton), for: .touchUpInside)
        
        let buttonWidth = view.frame.size.width / 2 - 20
        NSLayoutConstraint.activate([
            addBasket.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 10),
            addBasket.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addBasket.widthAnchor.constraint(equalToConstant: buttonWidth),
            addBasket.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addBasketButton(){
        detail!.adet = Int(stepper.value)
//        NetworkLayer.updateBasket(entityName: "Basket", restaurant: detail!, bag: disposeBag)

        guard let alert = returnCustomAlertOnMainThread(title: "Ürün başarıyla eklendi. 👍🏻", message: "Sepetinizi inceleyebilirsiniz.", buttonTitle: "Tamam") else { return }
        alert.actionButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true)
        }
    }
    
    @objc func dismissAlert(){
        dismiss(animated: true)
    }

}

