//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Олеся on 21.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let habitVC = UINavigationController(rootViewController: HabitsViewController())
    private let infoVC = UINavigationController(rootViewController: InfoViewController())
    private let tabBar = UITabBarController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setUpInitialFlow()
        setUpTabBarAppearance()
        setupNavigationBarAppearance()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
    }
    
    private func setUpInitialFlow() {
        infoVC.tabBarItem.title = "Информация"
        infoVC.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        habitVC.tabBarItem.title = "Привычки"
        habitVC.tabBarItem.image = UIImage(systemName: "rectangle.grid.1x2.fill")
        habitVC.navigationBar.prefersLargeTitles = true
        
        
        tabBar.tabBar.tintColor = UIColor(named: "Violet")
        tabBar.setViewControllers([habitVC, infoVC], animated: true)
    }
    
    private func setupNavigationBarAppearance(){
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .secondarySystemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        
    }
    
    
    private func setUpTabBarAppearance() {
        UITabBar.appearance().backgroundColor = .secondarySystemBackground
        
    }
}

