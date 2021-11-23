import UIKit

class CustomRestaurant: UIView {

    let restaurantName = CustomBodyLabel(textAlignment: .left)
    let restaurantDesc = CustomSecondaryLabel(fontSize: 14, textAlignment: .left)
    let restaurantImage = UIImageView()
    let uiview = UIView(frame: CGRect(x: 0, y: 0, width: 85, height: 75))
    
    let innerStackView = UIStackView()
    let outStackView   = UIStackView()
    
    let costLabel = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let divider = DividerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView(width: CGFloat, height: CGFloat){
        let imageViewWidthConstraint = NSLayoutConstraint(item: restaurantImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let imageViewHeightConstraint = NSLayoutConstraint(item: restaurantImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        restaurantImage.addConstraints([imageViewWidthConstraint, imageViewHeightConstraint])
    }
    
    private func configureUI(){
        
        configureInnerStackView()
        configureOutStackView()
        restaurantDesc.numberOfLines = 0
        
    }
    
    func setUIView(with imageString: String){
        if imageString == "fork"{
            restaurantImage.image = UIImage(named: "fork")
            
        }else{
            let url = URL(string: imageString)
            restaurantImage.kf.setImage(with: url)
            
        }
        
        uiview.addSubview(restaurantImage)
        restaurantImage.layer.masksToBounds = true
        restaurantImage.layer.cornerRadius = 5
        restaurantImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            restaurantImage.topAnchor.constraint(equalTo: uiview.topAnchor),
            restaurantImage.leadingAnchor.constraint(equalTo: uiview.leadingAnchor),
            restaurantImage.trailingAnchor.constraint(equalTo: uiview.trailingAnchor),
            restaurantImage.heightAnchor.constraint(equalTo: uiview.heightAnchor),
            
        ])
    }
        
    func configureInnerStackView(){
        restaurantName.textColor = .lightGray
        restaurantDesc.textColor = .lightGray
        innerStackView.addArrangedSubview(restaurantName)
        innerStackView.addArrangedSubview(restaurantDesc)
        innerStackView.axis = .vertical
        innerStackView.alignment = .leading
        
        innerStackView.spacing = 5
        innerStackView.distribution = .fillProportionally
        addSubview(innerStackView)
        
    }
    
    func configureOutStackView(){
        outStackView.addArrangedSubview(innerStackView)
        outStackView.addArrangedSubview(uiview)
        outStackView.axis = .horizontal
        outStackView.alignment = .center
        outStackView.spacing   = 5
        outStackView.distribution = .fillProportionally
        
        addSubview(outStackView)
        
        outStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            outStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            outStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            outStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9)
        ])
        
        
    }
    
    private func configureCostLabel(){
        addSubview(costLabel)
        costLabel.textColor = .systemOrange
        NSLayoutConstraint.activate([
            costLabel.topAnchor.constraint(equalTo: outStackView.bottomAnchor),
            costLabel.leadingAnchor.constraint(equalTo: outStackView.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor),
            costLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureDivider(){
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 5),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    
    func setUI(restaurant: RestaurantModel){
        self.restaurantName.text = restaurant.name
        self.restaurantDesc.text = "Lorem Ipsum"
        configureImageView(width: 80, height: 70)
        setUIView(with: restaurant.image)
        
    }
    
    func setUI(restaurant: RestaModel){
        self.restaurantName.text = restaurant.name
        self.restaurantDesc.text = restaurant.category
        configureImageView(width: 80, height: 70)
        setUIView(with: restaurant.image ?? "")
        
    }
    
    func setUI(restaurant: RestaurantMenuModel){
        configureCostLabel()
        self.restaurantName.text = restaurant.name
        self.restaurantDesc.text = restaurant.desc
        configureImageView(width: 25, height: 25)
        setUIView(with: "fork")
        guard let adet = restaurant.adet else {
            self.costLabel.text = (restaurant.cost) + " TL"
            return
        }
        self.costLabel.text = (restaurant.cost) + " TL x \(adet)"
        configureDivider()
        
    }
    
    
    
    
}
