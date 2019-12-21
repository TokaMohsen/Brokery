//
//  NavigationManager.swift
//  Brokery
//
//  Created by Sawy on 12/13/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import UIKit
class NavigationManager {
    
    static func setupTabBar() -> UITabBarController {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
        
        let homeItem = UITabBarItem()
        homeItem.title = "Home"
        homeItem.image = UIImage(named: "home_icon")
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.tabBarItem = homeItem
        
        let marketItem = UITabBarItem()
        marketItem.title = "Market Place"
        marketItem.image = UIImage(named: "home_icon")
        let marketPlaceVC = storyboard.instantiateViewController(withIdentifier: "MarketPlaceViewController")
        marketPlaceVC.tabBarItem = marketItem
        
        let chatItem = UITabBarItem()
        chatItem.title = "Messanger"
        chatItem.image = UIImage(named: "home_icon")
        let chatVC = UIViewController()
        chatVC.tabBarItem = chatItem
        
        let notificationItem = UITabBarItem()
        notificationItem.title = "Notifications"
        notificationItem.image = UIImage(named: "home_icon")
        let notificationVC = UIViewController()
        notificationVC.tabBarItem = notificationItem
        
        let moreItem = UITabBarItem()
        moreItem.title = "More"
        moreItem.image = UIImage(named: "home_icon")
        let moreVC = UIViewController()
        moreVC.tabBarItem = moreItem
        
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [homeVC, marketPlaceVC, chatVC, notificationVC, moreVC]
        
        return tabBarVC
    }
    
}
