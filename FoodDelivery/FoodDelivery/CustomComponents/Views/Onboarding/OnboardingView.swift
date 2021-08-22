//
//  OnboardingView.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 15.08.2021.
//

import UIKit

class OnboardingView: UIViewController {
    
    let titleLabel = CustomTitleLabel(textAlignment: .left, fontSize: 30)
    let imageView = UIImageView()
    let desc = CustomTitleLabel(textAlignment: .center, fontSize: 20)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
    }
    
    func setUI(title: String, image: UIImage, descText: String){
        self.titleLabel.text = title
        self.imageView.image = image
        self.desc.text = descText
    }
    
    private func configureUI(){
        configureTitle()
        configureImageView()
        configureDesc()
    }
    
    private func configureTitle(){
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureImageView(){
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureDesc(){
        view.addSubview(desc)
        desc.numberOfLines = 3
        desc.textColor = .secondaryLabel
        desc.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            desc.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
