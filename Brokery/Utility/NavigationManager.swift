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
    
    static let assetStoryboard = UIStoryboard(name: "Assets", bundle: nil)
    static let appointmentStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
    static let messagingStoryboard = UIStoryboard(name: "Messaging", bundle: nil)
    
    static func setupTabBar() -> UITabBarController {
        
        let homeItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        let homeVC = assetStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.tabBarItem = homeItem
        let homeNC = UINavigationController(rootViewController: homeVC)
        
        let marketItem = UITabBarItem(title: "Market Place", image: UIImage(named: "marketPlace"), selectedImage: UIImage(named: "marketPlace"))
        let marketPlaceVC = assetStoryboard.instantiateViewController(withIdentifier: "MarketPlaceViewController")
        marketPlaceVC.tabBarItem = marketItem
        let marketPlaceNC = UINavigationController(rootViewController: marketPlaceVC)
        
        let chatItem = UITabBarItem(title: "Messenger", image: UIImage(named: "messanger"), selectedImage: UIImage(named: "messanger"))
        let chatVC = messagingStoryboard.instantiateViewController(withIdentifier: "MessagingListViewController")
        chatVC.tabBarItem = chatItem
        let chatNC = UINavigationController(rootViewController: chatVC)
        
        let appointmentItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointment"), selectedImage: UIImage(named: "appointment"))
        let appointmentVC = appointmentStoryboard.instantiateViewController(withIdentifier: "AppointmentsListViewController") as! AppointmentsListViewController
        appointmentVC.tabBarItem = appointmentItem
        let appointmentNC = UINavigationController(rootViewController: appointmentVC)
        
//        let notificationItem = UITabBarItem(title: "Notifications", image: UIImage(named: "notifications"), selectedImage: UIImage(named: "notifications"))
//        let notificationVC = UIViewController()
//        notificationVC.tabBarItem = notificationItem
//        let notificationNC = UINavigationController(rootViewController: notificationVC)
        
        let moreItem = UITabBarItem(title: "More", image: UIImage(named: "menu"), selectedImage: UIImage(named: "menu"))
        let moreVC = assetStoryboard.instantiateViewController(withIdentifier: "MoreViewController")
        moreVC.tabBarItem = moreItem
        let moreNC = UINavigationController(rootViewController: moreVC)
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        let tabBarTintcolor = UIColor(red: 239/255, green: 180/255, blue: 28/255, alpha: 1)
        tabBarVC.tabBar.tintColor = tabBarTintcolor
        
        tabBarVC.viewControllers = [homeNC, marketPlaceNC, appointmentNC, chatNC, moreNC] //notificationNC
        
        return tabBarVC
    }
}
