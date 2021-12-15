//
//  CategoriesCell.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 7.08.2021.
//

import UIKit
import Kingfisher
import struct Common.RestaurantGenreModel

class CategoriesCell: UICollectionViewCell {
    static let identifier = "RestaurantCell"
    
    let imageView = UIImageView()
    let uiview = UIView()
    let restaurantName = CustomSecondaryLabel(fontSize: 14, textAlignment: .left)
    let favoriteButton = CustomButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        
        configureImageView()
        //configureFavoriteButton()
        configureRestaurantName()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(model: RestaurantGenreModel){
        let url = URL(string: model.imageUrlString)
        imageView.kf.setImage(with: url)
        self.restaurantName.text = model.name
    }
    
    
    
    private func configureImageView(){
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
        ])
    }
    
    private func configureFavoriteButton(){
        contentView.addSubview(favoriteButton)
        favoriteButton.setBackgroundImage(SFSymbols.hand, for: .normal)
        favoriteButton.tintColor = .lightGray
        favoriteButton.backgroundColor = Colors.grey10
        favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 25),
            favoriteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func favoriteButtonClicked(){
        // bunu sirasiVC'de yapacaksın.
    }
    
    private func configureRestaurantName(){
        //contentView.addSubview(restaurantName)
        contentView.addSubview(uiview)
        uiview.translatesAutoresizingMaskIntoConstraints = false
        
        restaurantName.textColor = .white
        
        
        let viewHeight:CGFloat = 50
        uiview.layer.insertSublayer(createGradientBackgorund(hexCode:  "#292929", height: viewHeight), at: 0)
        
        
        
        uiview.addSubview(restaurantName)
        //uiview.backgroundColor = UIColor(white: 0, alpha: 0.2)
        NSLayoutConstraint.activate([
            uiview.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            uiview.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            uiview.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            uiview.heightAnchor.constraint(equalToConstant: viewHeight),
            
            restaurantName.topAnchor.constraint(equalTo: uiview.topAnchor),
            restaurantName.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 10),
            restaurantName.trailingAnchor.constraint(equalTo: uiview.trailingAnchor),
            restaurantName.heightAnchor.constraint(equalTo: uiview.heightAnchor)
        ])
    }
    
    private func createGradientBackgorund(hexCode: String, height: CGFloat) -> CAGradientLayer{
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [hexStringToUIColor(hex: hexCode), UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: contentView.frame.size.width, height: height)
        return gradient
    }
}
