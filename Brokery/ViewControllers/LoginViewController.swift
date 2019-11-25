//
//  LoginViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/8/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    private lazy var authenticateService = AuthenticateService.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func loginUser(email: String , password: String)
    {
        
        if (email.isValidEmail() && !password.isEmpty)
        {            let params: JSON = ["email": email,
                                         "password": password
            ]
            var userInfo =  UIUserLogin(json: params)
            
            userInfo?.email = email
            userInfo?.password = password
            
            authenticateService.authenticate(forUser: userInfo!, errorDelegate: self) { (data, error) in
                if (error != nil)
                {
                    self.handleError(error: error!)
                }
                else
                {
                    print(data as Any)
                    let infoStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                    if let HomeVC = infoStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        self.navigationController?.pushViewController(HomeVC, animated: true)
                    }
                    
                }
            }
        }
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
                if let emailTxt = emailTextField.text , let passwordTxt = passwordTextField.text {
                    self.loginUser(email: emailTxt, password: passwordTxt)
                }
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        let infoStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let RegisterationVC = infoStoryboard.instantiateViewController(withIdentifier: "RegisterationViewController") as? RegisterationViewController {
            navigationController?.pushViewController(RegisterationVC, animated: true)
        }
        
    }
    @IBAction func loginWithFacebookBtnAction(_ sender: UIButton) {
    }
    @IBAction func loginWithGoogleBtnAction(_ sender: UIButton) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
