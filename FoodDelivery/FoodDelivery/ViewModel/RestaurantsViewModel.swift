import Foundation

protocol SearchRestaurantViewProtocol {
    var delegate: SearchRestaurantViewModelDelegate? { get set }
    var restaurants: [RestModel] { get }
    var numberOfItems: Int { get }
    func load()
}

protocol SearchRestaurantViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantsViewModel: SearchRestaurantViewProtocol {
    weak var delegate: SearchRestaurantViewModelDelegate?
    var restaurants: [RestModel] = []
    
    init() {
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants = list
            //self.delegate?.reloadData()
        }
    }
    
    var numberOfItems: Int {
        restaurants.count
    }
    
    func load() {
        delegate?.registerCell()
        delegate?.reloadData()
    }
    
    func willChangeRestaurants(completion: @escaping ([RestModel]?) -> Void){
        
        NetworkManager.shared.getFirebase(entityName: "Restaurants", type: RestModel.self) { (result) in
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
