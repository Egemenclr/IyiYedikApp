import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController {
    
    private let bag = DisposeBag()
    private let loadingView = LoadingView()
    private let searchController = UISearchController(searchResultsController: nil)
    var comeFromSiparisVC: String?
    
    private var viewSource = SearchListView(with: .home)
    
    // MARK: - Lifecycle
    override func loadView() {
        configureViewSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        loadingView.startLoading()
        configureSearchController()
        
        let itemSelected = viewSource.collectionView.rx.itemSelected.asObservable()
        
        let searchString = searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance)
            .asObservable()
        let inputs = SearchRestaurantViewModelInput(indexSelected: itemSelected,
                                                    searchString: searchString)
        let viewModel = SearchRestaurantViewModel(inputs)
        let outputs = viewModel.outputs(inputs)
        
        outputs.restaurant
            .drive(viewSource.collectionView.rx.items(cellIdentifier: SearchRestaurantsCell.identifier, cellType: SearchRestaurantsCell.self)) { indexPath, restaurant, cell in
                cell.configureUI(rest: restaurant)
            }.disposed(by: bag)
        
        outputs.isLoading
            .filter { !$0 }
            .do(onNext: { _ in self.loadingView.hideLoading() })
            .drive(loadingView.activityIndicator.rx.isHidden)
            .disposed(by: bag)
                
        outputs.showRestaurantDetail
                .drive(rx.showRestaurantDetail)
                .disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.searchBar.text = comeFromSiparisVC
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        comeFromSiparisVC = nil
    }
    
    private func configureViewSource(){
        view = viewSource
    }

    private func configureSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Yemek, mutfak veya restoran arayın"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

enum CollectionViewSize {
    case home
    case category
    
    var itemSize: CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        switch self {
        case .home:
            let width = screenWidth - 50
            let height = CGFloat(85)
            return CGSize(width: width, height: height)
            
        case .category:
            let width = (screenWidth - 4*10)/2
            let height = (screenHeight)/3
            return CGSize(width: width, height: height)
        }
    }
}
