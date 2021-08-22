import UIKit

class SearchVC: UIViewController, SearchRestaurantViewModelDelegate {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var comeFromSiparisVC: String?
    
    var collectionView: UICollectionView!
    
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
        viewModel.load()
        
    }
    
    private func configureCollectionView(){
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectonGridLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
            
        ])
    }
    
    func createCollectonGridLayout() -> UICollectionViewFlowLayout{
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
        searchController.searchBar.delegate = self
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

extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRestaurantsCell.identifier, for: indexPath) as! SearchRestaurantsCell
        guard let restaurant = viewModel?.restaurants[indexPath.row].restaurant else { return .init()}
        
        cell.configureUI(rest: restaurant)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let restaurant = viewModel?.restaurants[indexPath.row].restaurant else { return }
        let restaurantVC = RestaurantDetailVC(restaurant: restaurant)

        //restaurantVC.viewModel = RestaurantMenuViewModel()
        self.present(restaurantVC, animated: true)
    }
    
}
