import UIKit
import RxSwift
import RxRelay

class SepetimVC: UIViewController, RestaurantMenuViewModelDelegate {
    private let bag = DisposeBag()
    
    // MARK: Constraints
    
    
    private let emptyView = EmptyViewState(image: Images.emptyBasket!,
                                   messageText: "Sepetinizde ürün bulunmamaktadır.",
                                   messageDesc: "Semtinizdeki restoranları listeleyebilirsiniz.")
    private var collectionView : UICollectionView!
    private lazy var basketList    = BehaviorRelay<[RestaurantMenuModel]>(value: [])
    private let resultCost    = CustomTitleLabel(textAlignment: .left, fontSize: 16)
    private let paymentButton = CustomButton(backgroundColor: hexStringToUIColor(hex: "3C8D2F"), title: "Sipariş Ver")
    
    var viewModel: RestaurantMenuViewProtocol!{
        didSet{
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        configureUI()
        /*
         let basketDriver = viewModel.restaurants.asDriver()
         basketDriver.drive(collectionView.rx.items(cellIdentifier: SearchRestaurantsCell.identifier, cellType: SearchRestaurantsCell.self)) { index, model, cell in
             
             cell.configureUI(rest: model, index: index)
             cell.reloadListeDelegate = self
         }.disposed(by: bag)
         */
        
        
        basketList.bind(to: collectionView.rx.items(cellIdentifier: SearchRestaurantsCell.identifier, cellType: SearchRestaurantsCell.self)) { index, model, cell in
            cell.configureUI(rest: model, index: index)
            cell.reloadListeDelegate = self
        }.disposed(by: bag)
        
        basketList.skip(1)
            .subscribe { order in
            if order.element?.count == 0 {
                self.configureEmptyView()
            } else {
                self.collectionView.reloadData()
            }
        }.disposed(by: bag)
    }
    
    private func configureUI() {
        configureCollectionView()
        configureResultCost()
        configurePaymentButton()
        configureStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load { [weak self] list in
            guard let self = self else { return }
            self.basketList.accept(list)
        }
        
        DispatchQueue.main.async {
            self.setCostLabel()
        }
    }
    
    private func setCostLabel() {
        basketList
            .map{
                $0.map{
                    Double($0.adet ?? 1) * Double($0.cost)!
                }
                .reduce(0, { x, y in
                    x+y
                })
            }
            .map {
                " Toplam: \($0) ₺"
            }
            .bind(to: resultCost.rx.text).disposed(by: bag)
    }
    
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.90)
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
    
    private func configureEmptyView(){
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
        navigationController?.pushViewController(PaymentVC(list: basketList.value), animated: true)
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
    
    func registerCell() {
        collectionView.register(SearchRestaurantsCell.self,
                                forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension SepetimVC: ReloadListe{
    func reload(index: Int, listIndex: Int) {
        let alert = makeAlert(title: "Ürünü sil", message: "Silmek istediğinize emin misiniz?")
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { [weak self](handler) in
            guard let self = self else { return }
            
            var newValue = self.basketList.value
            newValue.remove(at: listIndex)
            self.basketList.accept(newValue)
            NetworkManager.shared.deleteFood(index: index)
            
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: { (handler) in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
