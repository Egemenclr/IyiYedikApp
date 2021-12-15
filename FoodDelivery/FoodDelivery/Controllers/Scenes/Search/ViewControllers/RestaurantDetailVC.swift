import UIKit
import SafariServices
import struct Common.RestaurantMenuModel
import struct Common.RestaModel

class RestaurantDetailVC: UIViewController {
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let favoriImage = UIImageView()
    let restaurantName = CustomTitleLabel(textAlignment: .left, fontSize: 24)
    let ratingStackView = UIStackView()
    let infoRestaurantStackView = UIStackView()
    let descriptionLabel = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let openHours = CustomTitleLabel(textAlignment: .left, fontSize: 14)
    let infoStackView = UIStackView()
    let divider = DividerView()
    
    let speedRating = CustomRatingView(title: "Hız", rating: "1.0", backgroundColor: .systemGreen)
    let serviceRating = CustomRatingView(title: "Servis", rating: "1.0", backgroundColor: .systemGreen)
    let lezzetRating = CustomRatingView(title: "Lezzet", rating: "1.0", backgroundColor: .systemGreen)
    // popular chosies collectionview
    
    // menu collectionView
    var  menuList: [RestaurantMenuModel?] = []
    var restaurant: RestaModel!
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        
    }
    
    init(restaurant: RestaModel){
        super.init(nibName: nil, bundle: nil)
        self.restaurant = restaurant
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        let url = URL(string: restaurant.image!)
        imageView.kf.setImage(with: url)
        restaurantName.text = restaurant.name
        self.speedRating.rating.text = String(restaurant.puan.hiz)
        self.serviceRating.rating.text = String(restaurant.puan.servis)
        self.lezzetRating.rating.text = String(restaurant.puan.lezzet)
        self.menuList = restaurant.menu
        
    }
    
    private func configureUI(){
        configureImageView()
        configureRatingsStackView(hiz: "1.0", servis: "1.0", lezzet: "1.0")
        configureRestaurantName()
        configureDescriptionLabel()
        
        configureInfoStackView()
        configureDivider()
        
        configureCollectionView()
        
        
    }
    
    private func configureImageView(){
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        
        
    }
    
    private func configureRestaurantName(){
        view.addSubview(restaurantName)
        
        
        restaurantName.textColor = .white
        NSLayoutConstraint.activate([
            restaurantName.bottomAnchor.constraint(equalTo: ratingStackView.topAnchor, constant: -20),
            restaurantName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            restaurantName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            restaurantName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureRatingsStackView(hiz: String, servis: String, lezzet: String){
        view.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(speedRating)
        ratingStackView.addArrangedSubview(serviceRating)
        ratingStackView.addArrangedSubview(lezzetRating)
        
        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .center
        ratingStackView.distribution = .fillEqually
        ratingStackView.spacing = 5.0
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -60),
            ratingStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            ratingStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            ratingStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureDescriptionLabel(){
        descriptionLabel.text = restaurant.category
        openHours.text = "Çalışma saatleri: 10:00 - 23:30"
        let favoriteButton = UIButton()
        favoriteButton.setImage(SFSymbols.bookmark, for: .normal)
        favoriteButton.addTarget(self, action: #selector(clickFavoriteButton), for: .touchUpInside)
        
        view.addSubview(infoRestaurantStackView)
        infoRestaurantStackView.axis = .horizontal
        infoRestaurantStackView.distribution = .fillProportionally
        
        let restaurantStackView = UIStackView()
        restaurantStackView.addArrangedSubview(descriptionLabel)
        restaurantStackView.addArrangedSubview(openHours)
        restaurantStackView.axis = .vertical
        restaurantStackView.spacing = 5.0
        restaurantStackView.alignment = .leading
        
        infoRestaurantStackView.addArrangedSubview(restaurantStackView)
        infoRestaurantStackView.addArrangedSubview(favoriteButton)
        infoRestaurantStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoRestaurantStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            infoRestaurantStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoRestaurantStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            infoRestaurantStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
    @objc private func clickFavoriteButton(_ button: UIButton){
        button.setImage(SFSymbols.bookmarkFill, for: .normal)
    }
    
    
    
    private func configureInfoStackView(){
        view.addSubview(infoStackView)
        let phoneView = CustomDetailView(image: "phone", title: "Call")
        phoneView.tag = 0
        phoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoStackViewClicked)))
        let mapView = CustomDetailView(image: "map", title: "Map")
        mapView.tag = 1
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoStackViewClicked)))
        let webView = CustomDetailView(image: "map", title: "Web")
        webView.tag = 2
        webView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoStackViewClicked)))
        infoStackView.addArrangedSubview(phoneView)
        infoStackView.addArrangedSubview(mapView)
        infoStackView.addArrangedSubview(webView)
        
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        infoStackView.distribution = .fill
        infoStackView.distribution = .fillProportionally
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: infoRestaurantStackView.bottomAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            infoStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func infoStackViewClicked(_ sender: UITapGestureRecognizer){
        switch sender.view?.tag {
        case 0:
            print("0")
            // open telephone
        case 1:
            let mapNC = UINavigationController(rootViewController: MapVC(coordinate: restaurant.coordinates))
            self.present(mapNC, animated: true)
        case 2:
            guard let url = URL(string: "https://www.yemeksepeti.com/") else { return }
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true)
        default:
            break
        }
    }
    
    private func configureDivider(){
        view.addSubview(divider)
        
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 5),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            divider.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate   = self
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
            
        ])
    }
    
    func createCollectonGridLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width  = (view.frame.width) - 50
        let height = CGFloat(95)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
    }

}

extension RestaurantDetailVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRestaurantsCell.identifier, for: indexPath) as! SearchRestaurantsCell
        guard let restaurant = menuList[indexPath.row] else { return .init()}
        cell.configureUI(rest: restaurant)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let restaurant = menuList[indexPath.row] else { return }
        let foodDetailVC = FoodDetailVC()
        foodDetailVC.setUI(detail: restaurant)
        let foodDetailNC = UINavigationController(rootViewController: foodDetailVC)
        
        self.present(foodDetailNC, animated: true)
    }
}
