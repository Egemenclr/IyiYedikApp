import UIKit
import RxSwift
import RxCocoa

class SearchVC: UIViewController, SearchRestaurantViewModelDelegate {
    
    private let bag = DisposeBag()
    
    private let searchController = UISearchController(searchResultsController: nil)
    var comeFromSiparisVC: String?
    private var collectionView: UICollectionView!
    
    var viewModel: SearchRestaurantViewProtocol!{
        didSet{
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        configureSearchController()
        configureCollectionView()
        
        let restaurants = viewModel.restaurants.share(replay: 1)
        
        let searchString = searchController.searchBar.rx.text
        let filteredUsers = Observable
            .combineLatest(searchString, restaurants) { str, restaurants in
            return restaurants.filter { $0.restaurant.name.hasPrefix(str!)}
            }
        
        filteredUsers
            .bind(to: self.collectionView.rx
                    .items(cellIdentifier: SearchRestaurantsCell.identifier,
                                   cellType: SearchRestaurantsCell.self)) { row, restaurant, cell in
            cell.configureUI(rest: restaurant)
        }.disposed(by: self.bag)
        
         collectionView.rx
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
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
            
        ])
    }
    
    private func createCollectonGridLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let width  = view.frame.width-50
        layout.itemSize = CGSize(width: width, height: 85)
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .vertical
        
        return layout
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
        collectionView.register(SearchRestaurantsCell.self, forCellWithReuseIdentifier: SearchRestaurantsCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}
