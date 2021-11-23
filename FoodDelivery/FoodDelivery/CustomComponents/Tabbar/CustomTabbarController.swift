//
//  CustomTabbarController.swift
//  FoodDelivery
//
//  Created by Egemen Inceler on 9.08.2021.
//

import UIKit

class CustomTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        viewControllers = [createSiparisNC(), createDiscoverNC(), createSepetimVC(), createProfileNC(), createSandbox()]
        UINavigationBar.appearance().barTintColor = .systemRed
        UINavigationBar.appearance().backgroundColor = .systemRed
        UINavigationBar.appearance().tintColor = .white
        
    }
    
    func createSiparisNC() -> UINavigationController{
        let siparisVC = SiparisVC()
        siparisVC.title = "Sipariş"
        siparisVC.tabBarItem = UITabBarItem(title: "Sipariş", image: SFSymbols.order, tag: 0)
        let viewModel = RestaurantGenreViewModel()
        siparisVC.viewModel = viewModel
        return UINavigationController(rootViewController: siparisVC)
    }
    
    func createDiscoverNC() -> UINavigationController{
        let discoverVC = SearchVC()
        discoverVC.title = "Ara"
        discoverVC.tabBarItem = UITabBarItem(title: "Ara", image: SFSymbols.magnifyingglass, tag: 1)
        discoverVC.viewModel = RestaurantsViewModel()
        return UINavigationController(rootViewController: discoverVC)
    }
    
    func createSepetimVC() -> UINavigationController{
        let sepetimVC = SepetimVC()
        sepetimVC.viewModel = RestaurantMenuViewModel()
        sepetimVC.title = "Sepetim"
        sepetimVC.tabBarItem = UITabBarItem(title: "Sepetim", image: SFSymbols.basket, tag: 2)
        
        return UINavigationController(rootViewController: sepetimVC)
    }
    
    func createProfileNC() -> UINavigationController{
        let profileVC = ProfileVC()
        profileVC.title = "Profil"
        profileVC.tabBarItem = UITabBarItem(title: "Profil", image: SFSymbols.profile, tag: 4)
        
        return UINavigationController(rootViewController: profileVC)
    }
    
    private func createSandbox() -> UINavigationController{
        let sandboxVC = SandBoxVC()
        sandboxVC.title = "Sandbox"
        sandboxVC.tabBarItem = UITabBarItem(title: "Profil", image: SFSymbols.profile, tag: 4)
        
        return UINavigationController(rootViewController: sandboxVC)
    }
}

extension CustomTabbarController: UITabBarControllerDelegate{
    
}
