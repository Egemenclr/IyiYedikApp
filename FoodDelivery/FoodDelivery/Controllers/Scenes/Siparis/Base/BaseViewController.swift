import UIKit
import RxSwift
import RxCocoa
import FoodDeliveryAPI

class BaseViewController: UIViewController {
    
    private lazy var categories: CategoriesViewController = {
        let controller = CategoriesViewController()
        return controller
    }()
    
    private lazy var pageViewController  = RestaurantPageVC()

    lazy var viewSource = SiparisView()
    // MARK: - Lifecycle
    override func loadView() {
        view = viewSource
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let pageViewControllerWidth = pageViewController.view.frame.size.width
        pageViewController.setUI(with: MockDatas().returnViewControllers(width: pageViewControllerWidth))
        configureViewStackView()
      
      FoodDeliveryAPIClient.testRun()
    }
    
    private func configureViewStackView() {
        [
            pageViewController,
            categories
        ].forEach {
            addChildController(controller: $0) {
                viewSource.stackView.addArrangedSubview($0)
            }
        }
    }
}
