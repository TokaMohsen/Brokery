//
//  MoreViewController.swift
//  Brokery
//
//  Created by Sawy on 12/28/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    private lazy var getUserInfoByTokenService = GetUserInfoByTokenService()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getUserInfoTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
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
    
    func setupView( name : String? , email : String? , jobTitle : String? , imagePath : String?) {
        
        if let name = name
        {
            self.name.text = name
        }
        else
        {
            self.name.text = "Default Name"
        }
        if let email = email
        {
            self.email.text = email
        }
        else
        {
            self.email.text = "Default Email"
        }
        if let jobTitle = jobTitle
        {
            self.jobTitle.text = jobTitle
        }
        else
        {
            self.jobTitle.text = "Default JobTitle"
        }
        
        if let imagePath = imagePath
        {
            let url = URL(string: BaseAPIURL + imagePath)
            SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                if image != nil {
                    self.profileImage.image = image
                    
                }
            })
        }
        else
        {
            
            self.profileImage.image = UIImage(named: "testAvatar")
            
        }
    }
    
    private func fetchData()
    {
        getUserInfoTask?.cancel()
        
        var userinfo = Resource<UserProfileObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUserInfoByTokenURL, method: .post)
        
        self.getUserInfoByTokenService.fetch(params: userinfo.params, method: .get, url: getUserInfoByTokenURL) { (response, error) in
            
            if let mappedResponse = response
            {
                let profile = mappedResponse.data?.userProfile
                DispatchQueue.main.async {
                    self.setupView(name: mappedResponse.data?.name, email: mappedResponse.data?.email, jobTitle: mappedResponse.data?.mobile, imagePath: profile?.photo)
                }
            } else if error != nil {
                
            }
        }
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
        LocalStore.deleteUserId()
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }
}
