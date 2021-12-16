import UIKit
import RxSwift
import RxCocoa

class SiparisVC: UIViewController, GenreListViewModelDelegate {
    
    private let bag = DisposeBag()
    
    private let pageViewController  = RestaurantPageVC()
    private lazy var initialPage = 0
    private let loadingView = LoadingView()
    private let viewSource = CategoryListView(size: .category)
    private let viewStackView = UIStackView()
    
    var viewModel: RestaurantGenreViewModel!{
        didSet{
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()
        
        Connectivity.isStillConnecting.subscribe{ value in
            switch value {
            case .success(_):
                print("internetConnection: \(value)")
            case .failure(_):
                let offlineVC = OfflineVC()
                self.present(offlineVC, animated: true)
            }
        }.disposed(by: bag)
        
        loadingView.startLoading()
        
        viewModel.isLoading
            .filter { $0 }
            .do(onNext: { _ in self.loadingView.hideLoading() })
            .asDriver(onErrorJustReturn: false)
            .drive(loadingView.activityIndicator.rx.isHidden)
            .disposed(by: bag)
            
        //self.loadingView.hideLoading()
        let pageViewControllerWidth = pageViewController.view.frame.size.width
        pageViewController.setUI(with: MockDatas().returnViewControllers(width: pageViewControllerWidth))
                
        configureViewStackView()
        configureCollectionView()
        viewModel.load()
        
        navigationController?.view.backgroundColor = .systemRed
        
        //DatabaseManager.shared.save(Favories(name: "Muhit Burger"))
        //print(DatabaseManager.shared.favorites)
        //DatabaseManager.shared.find(Favories(name: "q"))
        let damn = DatabaseManager.shared.favorites.filter{
            $0.restaurantName.prefix(0) == "q"
        }
        print(damn)
    }
    
    func reloadData() {
        viewSource.collectionView.reloadData()
    }
    
    private func configureCollectionView(){
    
        viewModel.restaurantsObservable
            .bind(to: viewSource.collectionView.rx.items(cellIdentifier: CategoriesCell.identifier, cellType: CategoriesCell.self)) { index, restaurant, cell in
                cell.accessibilityHint = "egemen"
                cell.setUI(model: restaurant)
            }.disposed(by: bag)
    }
    
    private func configureViewStackView(){
        view.addSubview(viewStackView)
        [
            pageViewController.view,
            viewSource
        ].forEach {viewStackView.addArrangedSubview($0)}
        viewStackView.distribution = .fill
        viewStackView.alignment = .fill
        viewStackView.spacing = 5
        viewStackView.axis = .vertical
        viewStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(viewStackView.alignFitEdges())
    }
    
    
}

/*
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     guard let tabBar = self.tabBarController else { return }
     let vc = tabBar.viewControllers?[1].children[0] as! SearchVC
     
     guard let title = viewModel?.restaurants[indexPath.row].name else { return }
     vc.comeFromSiparisVC = title
     tabBar.selectedIndex = 1
     
 }
 */
