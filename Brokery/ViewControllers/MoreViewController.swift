//
//  MoreViewController.swift
//  Brokery
//
//  Created by Sawy on 12/28/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var assetsView: UIView!
    @IBOutlet weak var rebsView: UIView!
    @IBOutlet weak var appointmentsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped(tapGestureRecognizer:)))
        profileView.addGestureRecognizer(profileTapGestureRecognizer)
        
        let assetsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(assetsTapped(tapGestureRecognizer:)))
        assetsView.addGestureRecognizer(assetsTapGestureRecognizer)
        
        let rebsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rebsTapped(tapGestureRecognizer:)))
        rebsView.addGestureRecognizer(rebsTapGestureRecognizer)
        
        let appointmentsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(appointmentsTapped(tapGestureRecognizer:)))
        appointmentsView.addGestureRecognizer(appointmentsTapGestureRecognizer)
        
        let settingsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(settingsTapped(tapGestureRecognizer:)))
        settingsView.addGestureRecognizer(settingsTapGestureRecognizer)
        
        let helpTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(helpTapped(tapGestureRecognizer:)))
        helpView.addGestureRecognizer(helpTapGestureRecognizer)
        
        let logoutTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logoutTapped(tapGestureRecognizer:)))
        logoutView.addGestureRecognizer(logoutTapGestureRecognizer)
    }
    
    @objc func profileTapped(tapGestureRecognizer: UITargetedDragPreview) {
    }
    
    @objc func assetsTapped(tapGestureRecognizer: UITargetedDragPreview) {
    }
    
    @objc func rebsTapped(tapGestureRecognizer: UITargetedDragPreview) {
    }
    
    @objc func appointmentsTapped(tapGestureRecognizer: UITargetedDragPreview) {
        let appointmentStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
        let appointmentVC = appointmentStoryboard.instantiateViewController(withIdentifier: "AddAppointmentViewController") as! AddAppointmentViewController
        self.navigationController?.pushViewController(appointmentVC, animated: true)
    }
    
    @objc func settingsTapped(tapGestureRecognizer: UITargetedDragPreview) {
    }
    
    @objc func helpTapped(tapGestureRecognizer: UITargetedDragPreview) {
    }
    
    @objc func logoutTapped(tapGestureRecognizer: UITargetedDragPreview) {
        LocalStore.deleteUserToken()
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}
