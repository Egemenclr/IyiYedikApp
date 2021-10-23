//
//  RestaurantPageVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 1.08.2021.
//

import UIKit
import RxSwift
import RxRelay

final class RestaurantPageVC: UIPageViewController {
    private let bag = DisposeBag()
    
    public var controllersObservable = BehaviorRelay<[UIViewController]>(value: [])
    public var currentIndexObservable = PublishSubject<Int>()

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
        controllersObservable.accept(viewController)
        
        let first = controllersObservable.value[0]
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }
    
}

extension RestaurantPageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllersObservable.value.firstIndex(of: viewController), index > 0 else { return nil }
        let prev = index - 1

        return controllersObservable.value[prev]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllersObservable.value.firstIndex(of: viewController), index < (controllersObservable.value.count - 1) else { return nil }
        let next = index + 1
        
        return controllersObservable.value[next]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllersObservable.value.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = pageViewController.viewControllers?.first else { return 0 }
        guard let firstVCIndex = controllersObservable.value.firstIndex(of: firstVC) else { return 0 }

        return firstVCIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            pendingIndex = controllersObservable.value.firstIndex(of: pendingViewControllers.first!)
        
        }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                currentIndexObservable.onNext(index)
            }
        }
    }
    
}
