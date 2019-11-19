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
    
    func handleError(error: Error) {
        
    }
    
}
