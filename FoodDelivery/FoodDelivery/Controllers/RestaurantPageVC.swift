//
//  RestaurantPageVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 1.08.2021.
//

import UIKit

protocol PageViewControllerDelegate: AnyObject {
    func setupPageController(numberPages: Int)
    func turnPageController(to index: Int)
}

final class RestaurantPageVC: UIPageViewController {

    var controllers = [UIViewController]()
    weak var pageControllerDelegate: PageViewControllerDelegate?

    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var currentIndex: Int?
    private var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }

    func setUI(with VCs: [UIViewController]) {
        populatePageVCs(viewController: VCs)
    }

    func populatePageVCs(viewController: [UIViewController]) {
        self.controllers = viewController
        pageControllerDelegate!.setupPageController(numberPages: controllers.count)
        guard let first = controllers.first else { return }
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }
    
}

extension RestaurantPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        let prev = index - 1

        return controllers[prev]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < (controllers.count - 1) else { return nil }
        let next = index + 1
        
        return controllers[next]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = pageViewController.viewControllers?.first else { return 0 }
        guard let firstVCIndex = controllers.firstIndex(of: firstVC) else { return 0 }

        return firstVCIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            pendingIndex = controllers.firstIndex(of: pendingViewControllers.first!)
        
        }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControllerDelegate?.turnPageController(to: index)
            }
        }
    }
    
}
