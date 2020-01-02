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
    
    static func setupTabBar() -> UITabBarController {
        let homeItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        
        let homeVC = assetStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        homeVC.tabBarItem = homeItem
        
        let marketItem = UITabBarItem(title: "Market Place", image: UIImage(named: "marketPlace"), selectedImage: UIImage(named: "marketPlace"))
        let marketPlaceVC = assetStoryboard.instantiateViewController(withIdentifier: "MarketPlaceViewController")
        marketPlaceVC.tabBarItem = marketItem
        
        //        let chatItem = UITabBarItem(title: "Messanger", image: UIImage(named: "messanger"), selectedImage: UIImage(named: "messanger"))
        //        let chatVC = UIViewController()
        //        chatVC.tabBarItem = chatItem
        
        let appointmentItem = UITabBarItem(title: "Appointments", image: UIImage(named: "appointment"), selectedImage: UIImage(named: "appointment"))
        let appointmentVC = appointmentStoryboard.instantiateViewController(withIdentifier: "AppointmentsListViewController") as! AppointmentsListViewController
        appointmentVC.tabBarItem = appointmentItem
        
        let notificationItem = UITabBarItem(title: "Notifications", image: UIImage(named: "notifications"), selectedImage: UIImage(named: "notifications"))
        let notificationVC = UIViewController()
        notificationVC.tabBarItem = notificationItem
        
        let moreItem = UITabBarItem(title: "More", image: UIImage(named: "menu"), selectedImage: UIImage(named: "menu"))
        let moreVC = assetStoryboard.instantiateViewController(withIdentifier: "MoreViewController")
        moreVC.tabBarItem = moreItem
        
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        let tabBarTintcolor = UIColor(red: 239/255, green: 180/255, blue: 28/255, alpha: 1)
        tabBarVC.tabBar.tintColor = tabBarTintcolor
        tabBarVC.viewControllers = [homeVC, marketPlaceVC, appointmentVC, notificationVC, moreVC]
        
        return tabBarVC
    }
}
