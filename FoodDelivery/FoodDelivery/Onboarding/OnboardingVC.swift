//
//  OnboardingVC.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 15.08.2021.
//

import UIKit

class OnboardingVC: UIViewController {
    let pageViewController  = RestaurantPageVC()
    let pageControl = UIPageControl()
    var initialPage = 0
    
    let nextButton = CustomButton(backgroundColor: .systemOrange, title: "Devam")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        pageViewController.pageControllerDelegate = self
        pageViewController.setUI(with: returnViewControllers())
        configurePageVC()
        configurePageControl()
        
        
    }
    
    private func returnViewControllers() -> [UIViewController]{
        
        var controllers = [UIViewController]()
        
        let viewC1 = OnboardingView()
        viewC1.setUI(title: "Canının İstediğini Ye", image: UIImage(named: "eating")!, descText: "Türkiye'nin doğusundan, batısına kadar canın ne isterse,")
        let viewC2 = OnboardingView()
        viewC2.setUI(title: "30 Dakikada Teslimat", image: UIImage(named: "delivery")!, descText: "İtalyan Pizzası üstüne Göçmen baklavası yemek istersen istediğin saatte,")
        let viewC3 = OnboardingView()
        viewC3.setUI(title: "Kolay Ödeme", image: UIImage(named: "payment")!, descText: "İstediğin ödeme yöntemi ile tek tuş ile sipariş verebilirsin.")
        
        
        controllers.append(viewC1)
        controllers.append(viewC2)
        controllers.append(viewC3)
        
        return controllers
    }
    
    private func configurePageVC() {
        view.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
        ])
    }
    
    private func configurePageControl() {
        // pageControl
        pageControl.frame = CGRect()
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        pageControl.currentPage = initialPage
        pageViewController.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureButton(){
        view.addSubview(nextButton)
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            nextButton.heightAnchor.constraint(equalToConstant: 35)
            
        ])
    }
    @objc private func nextButtonClicked(){
        UserDefaults.standard.setValue(true, forKey: "firstLogin")
        self.present(LoginVC(), animated: true)
    }
}

extension OnboardingVC: PageViewControllerDelegate{
    func setupPageController(numberPages: Int) {
        pageControl.numberOfPages = numberPages
    }
    
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        if pageControl.currentPage == 2{
            configureButton()
        }else{
            nextButton.removeFromSuperview()
        }
    }
}
