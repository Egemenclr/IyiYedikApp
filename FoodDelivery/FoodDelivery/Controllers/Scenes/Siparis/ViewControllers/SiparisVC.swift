import UIKit
import RxSwift
import RxCocoa

class SiparisVC: UIViewController, GenreListViewModelDelegate {
    
    private let bag = DisposeBag()
    
    private let pageViewController  = RestaurantPageVC()
    private lazy var initialPage = 0
    private var collectionView : UICollectionView!
    private let loadingView = LoadingView()
    
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
        let pageViewControllerWidth = pageViewController.view.frame.size.width - 25
        pageViewController.setUI(with: MockDatas().returnViewControllers(width: pageViewControllerWidth))
        
        configurePageVC()
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
    
    func registerCell() {
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: CategoriesCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        collectionView.backgroundColor = .systemBackground
    
        viewModel.restaurantsObservable
            .bind(to: collectionView.rx.items(cellIdentifier: CategoriesCell.identifier, cellType: CategoriesCell.self)) { index, restaurant, cell in
                cell.accessibilityHint = "egemen"
                cell.setUI(model: restaurant)
                //self.loadingView.hideLoading()
            }.disposed(by: bag)
            
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        guard let tabHegiht: CGFloat = self.tabBarController?.tabBar.frame.size.height else { return }
        
        let collectionViewHeight = view.frame.size.height - view.frame.size.height*0.33 - tabHegiht
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            
        ])
    }
    
    private func createCollectonGridLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width  = (view.frame.width - 4*10)/2
        let height = (view.frame.height)/3
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    private func configurePageVC() {
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
        ])
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

extension Driver {
    static func pipe() -> (observer: AnyObserver<Element>, driver: Driver<Element>) {
        let subject = PublishSubject<Element>()
        return (subject.asObserver(), subject.asDriver(onErrorDriveWith: .never()))
    }
}
