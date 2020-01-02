//
//  MoreViewController.swift
//  Brokery
//
//  Created by Sawy on 12/28/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var assetsView: UIView!
    @IBOutlet weak var rebsView: UIView!
    @IBOutlet weak var appointmentsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var logoutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "More")
        
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
    
    func setupView() {
        self.profileImage.image = UIImage(named: "testAvatar")
        self.name.text = "Mohamed Hassan"
        self.email.text = "E-mail Address"
        self.jobTitle.text = "Job Title"
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
