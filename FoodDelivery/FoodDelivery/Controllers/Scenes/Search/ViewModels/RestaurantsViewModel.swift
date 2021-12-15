import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Common

protocol SearchRestaurantViewProtocol {
    var delegate: SearchRestaurantViewModelDelegate? { get set }
    var restaurants: BehaviorRelay<[RestModel]> { get }
    var numberOfItems: Int { get }
}

protocol SearchRestaurantViewModelDelegate: AnyObject {
    func registerCell()
    func reloadData()
}

class RestaurantsViewModel: SearchRestaurantViewProtocol {
    weak var delegate: SearchRestaurantViewModelDelegate?
    
    var restaurants = BehaviorRelay<[RestModel]>(value: [])
    
    init() {
        willChangeRestaurants { [weak self] (liste) in
            guard let self = self,
                let list = liste else { return }
            self.restaurants.accept(list)
            //self.delegate?.reloadData()
        }
    }
    
    var numberOfItems: Int {
        restaurants.value.count
    }
    
    func willChangeRestaurants(completion: @escaping ([RestModel]?) -> Void){
        
        NetworkLayer.getFirebase(entityName: "Restaurants", type: RestModel.self) { (result) in
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
/*
 struct SearchRestaurantViewModelInput {
     let isLoading: Observable<Bool> = .never()
     var restaurants: Observable<[RestModel]> = .never()
 }

 struct SearchRestaurantViewModelOutput {
     let isLoading: Driver<Bool>
     var restaurant: Driver<[RestModel]> = .never()
 }

 typealias SearchRestaurantViewModel = (SearchRestaurantViewModelInput) -> SearchRestaurantViewModelOutput

 func searchRestaurantViewModel(
     _ inputs: SearchRestaurantViewModelInput
 ) -> SearchRestaurantViewModelOutput {
     return SearchRestaurantViewModelOutput(
         isLoading: inputs.isLoading.asDriver(onErrorDriveWith: .never()),
         restaurant: getRestaurants(inputs)
     )
 }

 private func getRestaurants(
     _ inputs: SearchRestaurantViewModelInput
 ) -> Driver<[RestModel]> {
     return Single<[RestModel]>.create { single in
         NetworkManager.shared.getFirebase(entityName: "Restaurants", type: RestModel.self) { (result) in
             switch result{
             case .success(let lists):
                 single(.success(lists))
                 break
             case .failure(_):
                 single(.failure(NetworkError.connectionError))
             }
         }
         return Disposables.create()
     }
     .asDriver(onErrorDriveWith: .never())
 }
 */
