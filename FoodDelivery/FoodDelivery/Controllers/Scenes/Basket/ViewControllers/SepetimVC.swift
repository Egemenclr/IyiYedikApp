import UIKit
import RxSwift
import RxRelay
import RxCocoa
import struct Common.RestaurantMenuModel

class SepetimVC: UIViewController {
    fileprivate let bag = DisposeBag()
    
    private lazy var emptyView = EmptyViewState(image: Images.emptyBasket!,
                                           messageText: "Sepetinizde ürün bulunmamaktadır.",
                                           messageDesc: "Semtinizdeki restoranları listeleyebilirsiniz."
    )
    private var collectionView : UICollectionView!
    private let resultCost    = CustomTitleLabel(textAlignment: .left, fontSize: 16)
    fileprivate let paymentButton = CustomButton(
        backgroundColor: hexStringToUIColor(hex: "3C8D2F"),
        title: "Sipariş Ver"
    )
    private let (trashButtonTappedObserver, trashButtonTappedEvent) = Observable<Int>.pipe()
    fileprivate let (popupDeleteObserver, popupDeleteEvent) = Observable<Void>.pipe()
    fileprivate let (viewDidAppearObserver, viewDidAppearEvent) = Observable<Void>.pipe()
    private let (emptyButtonObserver, emptyButtonEvent) = Observable<Void>.pipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        configureUI()
        
        let inputs = BasketViewModelInput(
            orderButtonTapped: rx.orderButtonTapped.asObservable(),
            orderDeleteButtonTapped: trashButtonTappedEvent,
            emptyButtonTapped: emptyView.rx.buttonTapped.asObservable(),
            deleteOrder: popupDeleteEvent,
            viewWillAppear: viewDidAppearEvent,
            bag: bag
        )
        
        let viewModel = BasketViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        
        outputs.foods.drive(collectionView.rx.items(cellIdentifier: SearchRestaurantsCell.identifier, cellType: SearchRestaurantsCell.self)) { index, model, cell in
            cell.configureUI(rest: model, index: index)
            
            cell.rx.trashButtonClicked
                .observe(on: MainScheduler.asyncInstance)
                .subscribe (onNext: {
                    guard let id = Int(model.id ?? "0") else { return }
                    self.trashButtonTappedObserver.onNext(id)
                }).disposed(by: cell.disposeBag)
            
        }.disposed(by: bag)
        
        outputs.foods
            .skip(1)
            .asObservable()
            .subscribe { order in
                if order.element?.count == 0 {
                    self.configureEmptyView()
                } else {
                    self.restoreCollectionView()
                }
            }.disposed(by: bag)
        
        outputs
            .showAlert
            .drive(rx.showDeleteAlert)
            .disposed(by: bag)
        
        outputs
            .showPayment
            .drive(rx.showPaymentVC)
            .disposed(by: bag)
        
        setCostLabel(outputs.foods.asObservable())
        
        outputs
            .showEmptyView
            .filter{$0}
            .drive(rx.showEmptyState)
            .disposed(by: bag)
            
    }
    
    private func configureUI() {
        configureCollectionView()
        configureStackView()
        configureResultCost()
        configurePaymentButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearObserver.onNext(())
    }
    
    private func setCostLabel(_ basketList: Observable<[RestaurantMenuModel]>) {
        basketList
            .map{
                $0.map{
                    Double($0.adet ?? 1) * Double($0.cost)!
                }
                .reduce(0, { x, y in
                    x+y
                })
            }
            .map { " Toplam: \($0) ₺" }
            .bind(to: resultCost.rx.text).disposed(by: bag)
    }
    
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
    
        let constant = CGFloat(5)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4*constant-50)
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
    }
    
    private func restoreCollectionView() {
        self.collectionView.backgroundView = nil
        self.collectionView.reloadData()
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


// MARK: - Rx + SepetimVC
extension Reactive where Base == SepetimVC {
    var orderButtonTapped: ControlEvent<Void> {
        base.paymentButton.rx.tap
    }
    
    var showDeleteAlert: Binder<String> {
        Binder(base) { target, message in
            let alertObservable = target.showAlert(
                message: message,
                positiveButtonTitle: "Evet",
                negativeButtonTitle: "Hayır"
            )
            
            alertObservable
                .asObservable()
                .filter { $0 }
                .subscribe(onNext: { [weak target] _ in
                    target?.popupDeleteObserver.onNext(())
                })
                .disposed(by: target.bag)
        }
    }
    
    var showPaymentVC: Binder<[RestaurantMenuModel]> {
        Binder(base) { target, orderList in
            let paymentVC = PaymentVC(list: orderList)
            target.show(paymentVC, sender: nil)
        }
    }
    
    var showEmptyState: Binder<Bool> {
        Binder(base) { target, arg  in
            guard let tabBar = target.tabBarController else { return }
            tabBar.selectedIndex = 1
        }
    }
}

// MARK: - Rx + UICollectionView
extension Reactive where Base: UICollectionView {
    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }
}
