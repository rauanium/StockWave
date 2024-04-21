//
//  MainTabBarViewController.swift
//  StockWave
//
//  Created by rauan on 4/21/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    //MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupTabbar()
            setupTabbarAppearance()
        }
        
        //MARK: - Setting tabbar
        private func setupTabbar() {
//            view.backgroundColor = .black
            let homeViewController = UINavigationController(rootViewController: HomeViewController())
            let portfolioViewController = UINavigationController(rootViewController: PortfolioViewController())
            let favouritesViewController = UINavigationController(rootViewController: FavouritesViewController())
            let searchViewController = UINavigationController(rootViewController: SearchViewController())
            
            homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
            portfolioViewController.tabBarItem = UITabBarItem(title: "Portfolio", image: UIImage(named: "portfolio_icon"), tag: 1)
            favouritesViewController.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "star"), tag: 1)
            searchViewController.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: "magnifyingglass"), tag: 1)
            
            let viewControllers: [UINavigationController] = [homeViewController, portfolioViewController, favouritesViewController, searchViewController]
            
            //settingup default navigation bar
            viewControllers.forEach {
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                
                navigationBarAppearance.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]
               
                navigationBarAppearance.backgroundColor = .white
                $0.navigationBar.standardAppearance = navigationBarAppearance
                $0.navigationBar.compactAppearance = navigationBarAppearance
                $0.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            }
            
            setViewControllers(viewControllers, animated: false)
        }
        
        private func setupTabbarAppearance() {
            
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.configureWithOpaqueBackground()
            tabbarAppearance.backgroundColor = .white
            tabBar.standardAppearance = tabbarAppearance
            tabBar.scrollEdgeAppearance = tabbarAppearance
            view.backgroundColor = .white
            tabBar.tintColor = .black
            tabBar.backgroundColor = .white
            tabBar.unselectedItemTintColor = .lightGray
        }

    }
