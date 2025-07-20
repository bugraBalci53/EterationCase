//
//  ViewController.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//

import UIKit

class ViewController: UIViewController {
    private var homeNav: UINavigationController = {
        let homeNav = UINavigationController(rootViewController: ListViewController())
        
        homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        
        return homeNav
    }()
    
    private var basketNav: UINavigationController = {
        let basketNav = UINavigationController(rootViewController: BasketViewController())
        
        basketNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), tag: 1)
        
        let basketCount = DataManager.shared.totalBasketItemCount()
        basketNav.tabBarItem.badgeValue = basketCount > 0 ? "\(basketCount)" : nil
        
        return basketNav
    }()
    
    private var favoritesNav: UINavigationController = {
        let favoritesNav = UINavigationController(rootViewController: UIViewController())
        favoritesNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), tag: 2)
        
        return favoritesNav
    }()
    
    private var accountNav: UINavigationController = {
        let accountNav = UINavigationController(rootViewController: UIViewController())
        accountNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)
        
        return accountNav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasketBadge), name: .basketUpdated, object: nil)
        initTabbar()
    }
    
    private func initTabbar() {
        let tabbar = UITabBarController()
        
        tabbar.tabBar.backgroundColor = .white
        
        tabbar.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabbar.tabBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        tabbar.tabBar.layer.shadowOpacity = 0.9
        tabbar.tabBar.layer.shadowRadius = 4
        tabbar.tabBar.layer.masksToBounds = false

        tabbar.viewControllers = [homeNav, basketNav, favoritesNav, accountNav]

        addChild(tabbar)
        view.addSubview(tabbar.view)
        tabbar.didMove(toParent: self)
    }
    
    @objc private func updateBasketBadge() {
        let count = DataManager.shared.totalBasketItemCount()
        basketNav.tabBarItem.badgeValue = count > 0 ? "\(count)" : nil
    }
}
