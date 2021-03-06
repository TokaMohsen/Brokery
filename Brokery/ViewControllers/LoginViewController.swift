//
//  LoginViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/8/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
//import FacebookLogin
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: BaseViewController , GIDSignInDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var getUserInfoByTokenService = GetUserInfoByTokenService.init()
    private lazy var userLoginInService = LoginService()
    private lazy var forgotPasswordService = ForgotPasswordService()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var postUserLoginInfoTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideErrorLabels()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        hideErrorLabels()
    }
    
    @IBAction func loginWithFacebookAction(_ sender: UIButton) {
    }
    @IBAction func forgotPassword(_ sender: UIButton) {
        forgotPassword()
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if let emailTxt = emailTextField.text, emailTxt.isValidEmail(),
            let passwordTxt = passwordTextField.text, passwordTxt.isValidString() {
            postUserLoginInfoTask?.cancel()
            
            activityIndicator.startAnimating()
            
            var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: AuthentactionURL, method: .post)
            userinfo.params = ["email": emailTxt,
                               "password": passwordTxt]
            
            
            self.userLoginInService.signIn(params: userinfo.params, method: .post, url: AuthentactionURL) {[weak self] (response, error) in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                
                if let mappedResponse = response?.data {
                    if let userId = mappedResponse.id {
                        LocalStore.storeUserID(id: userId)
                    }
                    DispatchQueue.main.async {
                        self?.dismiss(animated: true, completion: nil)
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        appDelegate.window?.rootViewController = NavigationManager.setupTabBar()
                        appDelegate.window?.makeKeyAndVisible()
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self?.emailErrorLabel.text = "The email or Password you entered is incorrect"
                        self?.passwordErrorLabel.text = "The email or Password you entered is incorrect"
                    }
                    self?.showErrorLabels()
                }
            }
        } else {
            if let emailTxt = emailTextField.text, !emailTxt.isValidEmail() {
                DispatchQueue.main.async {
                    self.emailErrorLabel.text = "Enter a valid Email"
                }
            }
            
            if let passwordTxt = passwordTextField.text, !passwordTxt.isValidString() {
                DispatchQueue.main.async {
                    self.passwordErrorLabel.text = "Enter your password"
                }
            }
            showErrorLabels()
        }
    }
    
    
    private func forgotPassword()
    {
        postUserLoginInfoTask?.cancel()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        var userinfo = Resource<StatusObject , CustomError>(jsonDecoder: JSONDecoder(), path: forgotPasswordURL, method: .post)
        if let emailTxt = emailTextField.text, emailTxt.isValidEmail()
        {
            userinfo.params = ["Email": emailTxt]
            self.forgotPasswordService.fetch(params: userinfo.params, method: .get, url: forgotPasswordURL) { (response, error) in
                DispatchQueue.main.async {
                    //            self.activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.stopAnimating()
                }
                
                if let mappedResponse = response
                {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with: "Email has been sent to you successfully", title: "Confirmation")
                    }
                    
                } else if error != nil {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with: "Server error", title: "Error")
                    }
                }
            }
        }
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        let infoStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let RegisterationVC = infoStoryboard.instantiateViewController(withIdentifier: "RegisterationViewController") as? RegisterationViewController {
            self.navigationController?.pushViewController(RegisterationVC, animated: true)
        }
    }
    
    @IBAction func loginWithFacebookBtnAction(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = result?.token else {
                print("Failed to get access token")
                return
            }
            guard let currentUser = Auth.auth().currentUser else {
                print("Failed to get email")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                else
                {
                    self.postUserLoginInfoTask?.cancel()
                    
                    self.activityIndicator.startAnimating()
                    
                    var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: loginWithFacebookURL, method: .post)
                    userinfo.params = ["email": currentUser.email! ,
                                       "password": facebookPasswordConst,
                                       "tokenSocialMedia": accessToken.tokenString]
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.userLoginInService.signIn(params: userinfo.params, method: .post, url: loginWithFacebookURL) { (response, error) in
                            if let mappedResponse = response?.data
                            {
                                if let userId = mappedResponse.id {
                                    LocalStore.storeUserID(id: userId)
                                }
                                
                                let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                                if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                    UIApplication.shared.keyWindow?.rootViewController = HomeVC
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else if error != nil {
                                DispatchQueue.main.async {
                                    self.showErrorAlert(with: "Error", title: "Server Error")
                                }
                            }
                        }
                    }
                }
            })
            
        }
    }
    @IBAction func loginWithGoogleBtnAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    private func hideErrorLabels() {
        DispatchQueue.main.async {
            self.emailErrorLabel.isHidden = true
            self.passwordErrorLabel.isHidden = true
        }
    }
    
    private func showErrorLabels() {
        DispatchQueue.main.async {
            self.emailErrorLabel.isHidden = false
            self.passwordErrorLabel.isHidden = false
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.fetchGoogleUser(with: user)
    }
    
    func fetchGoogleUser(with user: GIDGoogleUser?) {
        if user != nil {
            if let token = user?.authentication.idToken
            {
                self.postUserLoginInfoTask?.cancel()
                
                self.activityIndicator.startAnimating()
                
                var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: LoginWithGoogleURL, method: .post)
                if let email = user?.profile.email , let name = user?.profile.name {
                    userinfo.params = ["email": email ,
                                       "password": googlePasswordConst,
                                       "tokenSocialMedia": token
                    ]
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.userLoginInService.signIn(params: userinfo.params, method: .post, url: LoginWithGoogleURL) { (response, error) in
                        if let mappedResponse = response?.data
                        {
                            if let userId = mappedResponse.id {
                                LocalStore.storeUserID(id: userId)
                            }
                            let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                            if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                UIApplication.shared.keyWindow?.rootViewController = HomeVC
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        } else if error != nil {
                            DispatchQueue.main.async {
                                self.showErrorAlert(with: "Error", title: "Server Error")
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
