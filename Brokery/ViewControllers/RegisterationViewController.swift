//
//  RegisterationViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/8/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class RegisterationViewController: BaseViewController {
    
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mobileNumberTextField: UITextField!
    
    private lazy var registerationService = RegisterationService.init()
    private lazy var getUserInfoByTokenService = GetUserInfoByTokenService.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func registerUser(email: String , password: String , mobile : String , fullname : String)
    {
        
        if (email.isValidEmail() && mobile.isValidMobileNumber() && !password.isEmpty && !fullname.isEmpty ){
//        {            let params: JSON = ["email": email,
//                                         "password": password,
//                                         "mobile": mobile,
//                                         "name": email
//            ]
            let userInfo = UIAccountDto(email: email , password: password , mobile: mobile , name: email)
            
//            userInfo.email = email
//            userInfo.mobile = mobile
//            userInfo.password = password
//            userInfo.name = email
            
            registerationService.Register(forUser: userInfo, errorDelegate: self) { (data, error) in
                if (error != nil)
                {
                    self.handleError(error: error!)
                }
                else
                {
                    if let accessToken = LocalStore.getUserToken(){
                        self.getUserInfoByTokenService.fetch(forUser: userInfo, errordelegate: self) { (data, error) in
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
            }
    }
    }
    @IBAction func registerBtnAction(_ sender: UIButton) {
        if let emailTxt = emailTextField.text , let passwordTxt = passwordTextField.text , let mobileTxt = mobileNumberTextField.text , let fullname = fullNameTextField.text {
            self.registerUser(email: emailTxt, password: passwordTxt, mobile: mobileTxt, fullname: fullname)
        }
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
