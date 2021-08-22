import Foundation

protocol GenreListViewProtocol {
    var delegate: GenreListViewModelDelegate? { get set }
    var restaurants: [RestaurantGenreModel] { get }
    var numberOfItems: Int { get }
    func load()
}

protocol GenreListViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantGenreViewModel: GenreListViewProtocol {
    var restaurants: [RestaurantGenreModel] = []
    weak var delegate: GenreListViewModelDelegate?
    
    init() {
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants = list
            self.delegate?.reloadData()
        }
    }
    var numberOfItems: Int {
        return restaurants.count
    }
    
    func load() {
        delegate?.registerCell()
        delegate?.reloadData()
    }
    
    func willChangeRestaurants(completion: @escaping ([RestaurantGenreModel]?) -> Void){
        
        NetworkManager.shared.getFirebase(entityName: "Categories", type: RestaurantGenreModel.self) { (result) in
            switch result{
            case .success(let lists):
                completion(lists)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
