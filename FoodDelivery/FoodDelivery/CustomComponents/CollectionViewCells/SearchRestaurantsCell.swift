//
//  SearchRestaurantsCell.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 9.08.2021.
//

import UIKit

class SearchRestaurantsCell: UICollectionViewCell {
    static let identifier = "SearchRestaurantsCell"
    
    let restaurant = CustomRestaurant()
    let button = UIButton()
    
    var detail: RestaurantMenuModel?
    var listIntex: Int?
    var reloadListeDelegate: ReloadListe?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureRestaurant()
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(rest: RestaurantMenuModel){
        self.detail = rest
        restaurant.setUI(restaurant: rest)
    }
    
    func configureUI(rest: RestaModel){
        contentView.backgroundColor = hexStringToUIColor(hex: "F4F4F5")
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        restaurant.setUI(restaurant: rest)
    }
    func configureUI(rest: RestaurantMenuModel, index: Int){
        self.detail = rest
        self.listIntex = index
        restaurant.setUI(restaurant: rest)
        configureButton()
    }
    
    private func configureButton(){
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SFSymbols.trash, for: .normal)
        button.addTarget(self, action: #selector(trashButtonClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: restaurant.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureRestaurant(){
        contentView.addSubview(restaurant)
        
        restaurant.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restaurant.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            restaurant.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            restaurant.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            restaurant.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc func trashButtonClicked(){
        
        guard let index = Int((detail?.id)!) else { return }
        reloadListeDelegate?.reload(index: index, listIndex: listIntex!)
    }
}


protocol ReloadListe{
    func reload(index: Int, listIndex: Int)
}
