import UIKit
import RxSwift
import RxCocoa
import struct Common.RestModel

class SearchVC: UIViewController {
    
    private let bag = DisposeBag()
    var containerView = SearchListView(with: .home)
    
    let (restaurantListObservable, restaurantList)  = Driver<[RestModel]>.pipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemBackground
        
        let itemSelected = containerView.collectionView.rx.itemSelected.asObservable()
        let inputs = SearchRestaurantViewModelInput(
            indexSelected: itemSelected,
            list: restaurantList.asObservable()
        )
//        var inputs: SearchRestaurantViewModelInput {
//            return SearchRestaurantViewModelInput(
//                indexSelected: itemSelected,
//                list: restaurantList.asObservable()
//            )
//        }
        let viewModel = SearchRestaurantViewModel(inputs)
        let outputs = viewModel.outputs(inputs)

        let datasource = SearchVC.datasource()
        
        bag.insert(
            outputs.sections.drive(containerView.collectionView.rx.items(dataSource: datasource)),
            outputs.showRestaurantDetail.drive(rx.showRestaurantDetail)
        )
                
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(containerView.alignFitEdges())
    }
}

enum CollectionViewSize {
    case home
    case category
    case popular
    
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
            
        case .popular:
            let width = 70.0
            let height = 20.0
            return CGSize(width: width, height: height)
        }
    }
}
