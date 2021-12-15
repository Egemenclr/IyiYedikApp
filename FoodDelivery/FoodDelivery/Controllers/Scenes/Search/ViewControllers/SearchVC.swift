import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController, SearchRestaurantViewModelDelegate {
    
    private let bag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    var comeFromSiparisVC: String?
    
    private var viewSource = SearchListView(with: CGSize(width: UIScreen.main.bounds.size.width - 50,
                                                         height: 85))
    
    var viewModel: SearchRestaurantViewProtocol!{
        didSet{
            viewModel.delegate = self
        }
    }
    
    override func loadView() {
        configureViewSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        configureSearchController()
        
        let restaurants = viewModel.restaurants.share(replay: 1)
        
        let searchString = searchController.searchBar.rx.text
        let filteredUsers = Observable
            .combineLatest(searchString, restaurants) { str, restaurants in
            return restaurants.filter { $0.restaurant.name.hasPrefix(str!)}
            }
        
        filteredUsers
            .bind(to: self.viewSource.collectionView.rx
                    .items(cellIdentifier: SearchRestaurantsCell.identifier,
                                   cellType: SearchRestaurantsCell.self)) { row, restaurant, cell in
            cell.configureUI(rest: restaurant)
        }.disposed(by: self.bag)
        
        viewSource.collectionView.rx
            .itemSelected.subscribe { indexPath in
                 guard let index = indexPath.element?.row else { return }
                 
                 filteredUsers.subscribe { temp in
                     guard temp.element!.count > 0,
                        let restaurant = temp.element?[index].restaurant else { return }
                     let restaurantVC = RestaurantDetailVC(restaurant: restaurant)
                     self.present(restaurantVC, animated: true)
                 }.dispose()
             }.disposed(by: bag)
        
    }
    
    private func configureViewSource(){
        view = viewSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.searchBar.text = comeFromSiparisVC
    }
    
    private func configureSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Yemek, mutfak veya restoran arayın"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func registerCell() {
        viewSource.collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
    }
    
    func reloadData() {
        viewSource.collectionView.reloadData()
    }
}
