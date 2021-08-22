import UIKit


class SepetimVC: UIViewController, RestaurantMenuViewModelDelegate {
    
    let emptyView = EmptyViewState(image: Images.emptyBasket!, messageText: "Sepetinizde ürün bulunmamaktadır.", messageDesc: "Semtinizdeki restoranları listeleyebilirsiniz.")
    
    var collectionView : UICollectionView!
    var basketList: [RestaurantMenuModel] = []
    let resultCost = CustomTitleLabel(textAlignment: .left, fontSize: 16)
    let paymentButton = CustomButton(backgroundColor: hexStringToUIColor(hex: "3C8D2F"), title: "Sipariş Ver")
    
    var viewModel: RestaurantMenuViewProtocol!{
        didSet{
            viewModel.delegate = self
            self.basketList = viewModel.restaurants
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    private func configureUI(){
        configureCollectionView()
        configureResultCost()
        configurePaymentButton()
        configureStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
        self.basketList = viewModel.restaurants
        
        self.reloadCollectionView()
        DispatchQueue.main.async {
            self.setCostLabel()
        }
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90)
            
        ])
    }
    
    func createCollectonGridLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width  = (view.frame.width) - 50
        let height = (view.frame.height)/10
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    func configureEmptyView(){
        
        collectionView.backgroundView = emptyView
        emptyView.setButton(text: "RESTORANLARI LİSTELE", backgroundColor: .systemGreen)
        emptyView.button.addTarget(self, action: #selector(emptyButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func emptyButtonClicked(){
        guard let tabBar = self.tabBarController else { return }
        tabBar.selectedIndex = 1
    }
    
    private func configureResultCost(){
        let heightConstant: CGFloat = 50
        let heighteightConstraint = NSLayoutConstraint(item: resultCost, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightConstant)
        resultCost.addConstraints([heighteightConstraint])
        
        resultCost.backgroundColor = .systemGreen
        
    }
    
    private func configurePaymentButton(){
        
        let heightConstant: CGFloat = 50
        let heighteightConstraint = NSLayoutConstraint(item: paymentButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightConstant)
        paymentButton.addConstraints([heighteightConstraint])
        paymentButton.layer.cornerRadius = 0
        paymentButton.titleLabel?.font = Fonts.helvetica?.withSize(16)
        paymentButton.addTarget(self, action: #selector(openPaymentScreen), for: .touchUpInside)
    }
    
    @objc private func openPaymentScreen(){
        navigationController?.pushViewController(PaymentVC(list: basketList), animated: true)
    }
   
    
    private func configureStackView(){
        let stackView = UIStackView(arrangedSubviews: [resultCost, paymentButton])
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        resultCost.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        paymentButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension SepetimVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if basketList.count == 0 {
            configureEmptyView()
            paymentButton.isHidden = true
            resultCost.isHidden = true
            
        }else{paymentButton.isHidden = false
            resultCost.isHidden = false
            collectionView.backgroundView = .none
        }
        
        return basketList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRestaurantsCell.identifier, for: indexPath) as! SearchRestaurantsCell
        
        let restaurant = basketList[indexPath.row]
        
        cell.configureUI(rest: restaurant, index: indexPath.row)
        cell.reloadListeDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func registerCell() {
        collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func setCostLabel(){
        var result = 0.0
        for item in self.basketList{
            result += Double(item.adet ?? 1) * Double(item.cost)!
        }
        self.resultCost.text = " Toplam: \(result) TL"
    }
    
    private func reloadCollectionView(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.viewModel.load()
        }
    }
}

extension SepetimVC: ReloadListe{
    func reload(index: Int, listIndex: Int) {
        let alert = makeAlert(title: "Ürünü sil", message: "Silmek istediğinize emin misiniz?")
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { [weak self](handler) in
            guard let self = self else { return }
            self.basketList.remove(at: listIndex)
            
            self.setCostLabel()
            NetworkManager.shared.deleteFood(index: index)
            self.reloadCollectionView()
            
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: { (handler) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
