//
//  SceneDelegate.swift
//  PopcornBox
//
//  Created by 이주희 on 2023/05/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = SearchViewController()
        let myPageVC = MyPageViewController()
        
        let firstTabBarItem = UITabBarItem(title: "First", image: UIImage(systemName: "house.fill"), tag: 0)
            let secondTabBarItem = UITabBarItem(title: "Second", image: UIImage(systemName: "magnifyingglass"), tag: 1)
            let thirdTabBarItem = UITabBarItem(title: "Third", image: UIImage(systemName: "person.fill"), tag: 2)
        
        homeVC.tabBarItem = firstTabBarItem
        searchVC.tabBarItem = secondTabBarItem
        myPageVC.tabBarItem = thirdTabBarItem
        
        let tabBarVC = UITabBarController()
        tabBarVC.setViewControllers([homeVC, searchVC, myPageVC], animated: false)
                                    
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
        self.window = window
    }
}
