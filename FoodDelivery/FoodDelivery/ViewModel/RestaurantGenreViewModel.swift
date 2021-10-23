import Foundation
import RxSwift
import RxRelay

protocol GenreListViewProtocol {
    var delegate: GenreListViewModelDelegate? { get set }
    
    var restaurantsObservable: BehaviorRelay<[RestaurantGenreModel]> { get }
    var numberOfItems: Int { get }
    func load()
}

protocol GenreListViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantGenreViewModel: GenreListViewProtocol {
    
    var restaurantsObservable = BehaviorRelay<[RestaurantGenreModel]>(value: [])

    weak var delegate: GenreListViewModelDelegate?
    
    init() {
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurantsObservable.accept(list)
            self.delegate?.reloadData()
        }
    }
    var numberOfItems: Int {
        return restaurantsObservable.value.count
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
