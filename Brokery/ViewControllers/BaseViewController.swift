//
//  BaseViewController.swift
//  Brokery
//
//  Created by Sawy on 11/18/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

protocol HandleErrorDelegate {
    func handleError(error: Error)
}

class BaseViewController: UIViewController, HandleErrorDelegate {
    
    func setupNavigationBar(title: String) {
        if let navBar = self.navigationController?.navigationBar {
            navBar.barStyle = .black
            navBar.barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            navBar.tintColor = UIColor(red: 239/255, green: 180/255, blue: 28/255, alpha: 1)
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 239/255, green: 180/255, blue: 28/255, alpha: 1)]
            navBar.topItem?.title = title
        }
        self.navigationItem.title = title
    }
    
    func handleError(error: Error) {
        
    }
}
