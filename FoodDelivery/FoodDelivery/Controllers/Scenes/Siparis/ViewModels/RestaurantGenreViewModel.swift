import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Common

protocol GenreListViewProtocol {
    var delegate: GenreListViewModelDelegate? { get set }
    
    var restaurantsObservable: BehaviorRelay<[RestaurantGenreModel]> { get }
    var numberOfItems: Int { get }
    func load()
}

protocol GenreListViewModelDelegate: AnyObject {
    func reloadData()
}

class RestaurantGenreViewModel: GenreListViewProtocol {
    //var isLoading: Driver<Bool> = Observable.just(false).asDriver(onErrorDriveWith: .never())
    var isLoading = PublishSubject<Bool>()
    var restaurantsObservable = BehaviorRelay<[RestaurantGenreModel]>(value: [])

    weak var delegate: GenreListViewModelDelegate?
    
    init() {
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurantsObservable.accept(list)
            self.isLoading.on(.next(true))
            self.delegate?.reloadData()
        }
    }
    var numberOfItems: Int {
        return restaurantsObservable.value.count
    }
    
    func load() {
        delegate?.reloadData()
    }
    
    func willChangeRestaurants(completion: @escaping ([RestaurantGenreModel]?) -> Void){
        
        NetworkLayer.getFirebase(entityName: "Categories", type: RestaurantGenreModel.self) { (result) in
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
