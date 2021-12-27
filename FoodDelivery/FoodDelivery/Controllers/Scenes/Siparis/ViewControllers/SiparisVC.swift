import UIKit
import RxSwift
import RxCocoa

class SiparisVC: UIViewController {
    
    private let bag = DisposeBag()
    
    private let pageViewController  = RestaurantPageVC()
    private let loadingView = LoadingView()
    private let containerView = CategoryListView(size: .category)
    lazy var viewSource = SiparisView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = viewSource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()
        
        let indexSelected = containerView.collectionView.rx.itemSelected
            .asObservable()
        
        let inputs = SiparisViewModelInput(indexSelected: indexSelected)
        let viewModel = SiparisViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        loadingView.startLoading()
        
        outputs.restaurantList
            .drive(containerView.collectionView.rx.items(cellIdentifier: CategoriesCell.identifier, cellType: CategoriesCell.self)) { index, restaurant, cell in
                cell.setUI(model: restaurant)
            }.disposed(by: bag)
        
        outputs.isLoading
            .filter { !$0 }
            .do(onNext: { _ in self.loadingView.hideLoading() })
            .drive(loadingView.activityIndicator.rx.isHidden)
            .disposed(by: bag)

        outputs.showSearchVC
                .drive(rx.showSearchViewControllerWithTitle)
                .disposed(by: bag)

        Connectivity.isStillConnecting.subscribe{ value in
            switch value {
            case .success(_):
                print("internetConnection: \(value)")
            case .failure(_):
                let offlineVC = OfflineVC()
                self.present(offlineVC, animated: true)
            }
        }.disposed(by: bag)
        
        let pageViewControllerWidth = pageViewController.view.frame.size.width
        pageViewController.setUI(with: MockDatas().returnViewControllers(width: pageViewControllerWidth))
                
        configureViewStackView()
        
        
        navigationController?.view.backgroundColor = .systemRed
        
        //DatabaseManager.shared.save(Favories(name: "Muhit Burger"))
        //print(DatabaseManager.shared.favorites)
        //DatabaseManager.shared.find(Favories(name: "q"))
        let damn = DatabaseManager.shared.favorites.filter{
            $0.restaurantName.prefix(0) == "q"
        }
    }
    
    private func configureViewStackView(){
        [
            pageViewController.view,
            containerView
        ].forEach {viewSource.stackView.addArrangedSubview($0)}
    }
}
