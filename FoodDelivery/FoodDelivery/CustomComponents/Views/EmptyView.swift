//
//  EmptyView.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 14.08.2021.
//

import UIKit
import RxSwift
import RxCocoa

class EmptyViewState: UIView {
    let imageView = UIImageView()
    let messageBodyText =  CustomBodyLabel(textAlignment: .center)
    let messageDescText = CustomTitleLabel(textAlignment: .center, fontSize: 14)
    let button = CustomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, messageText: String, messageDesc: String){
        self.init(frame: .zero)
        configureImageView(image)
        configureMessageLabel(messageText)
        configureMessageDescLabel(messageDesc)
        configureButton()
    }
    
    private func configureImageView(_ image: UIImage){
        imageView.image = image
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .lightGray
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureMessageLabel(_ message: String){
        addSubview(messageBodyText)
        
        messageBodyText.text = message
        messageBodyText.textColor = .label
        messageBodyText.numberOfLines = 0
        
        messageBodyText.font = Fonts.helvetica_bold?.withSize(16)
        
        
        NSLayoutConstraint.activate([
            messageBodyText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            //messageBodyText.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            messageBodyText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            messageBodyText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            messageBodyText.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    private func configureMessageDescLabel(_ message: String){
        addSubview(messageDescText)
        messageDescText.text = message
        messageDescText.textColor = .secondaryLabel
        messageDescText.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            messageDescText.topAnchor.constraint(equalTo: messageBodyText.bottomAnchor, constant: 10),
            messageDescText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            messageDescText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            messageDescText.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureButton(){
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: messageDescText.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}

extension EmptyViewState{
    func setButton(text: String, backgroundColor: UIColor){
        button.setTitle(text, for: .normal)
        button.backgroundColor = backgroundColor
    }
}

// MARK: - Rx + EmptyView

extension Reactive where Base == EmptyViewState {
    var buttonTapped: ControlEvent<Void> {
        base.button.rx.tap
    }
}
