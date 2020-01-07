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
        setupNavigationBar(title: "Login")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        hideErrorLabels()
    }
    
    @IBAction func loginWithFacebookAction(_ sender: UIButton) {
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
                    self?.showErrorLabels()
                }
            }
        } else {
            if let emailTxt = emailTextField.text, !emailTxt.isValidEmail() {
                emailErrorLabel.text = "Enter a valid Email"
            }
            
            if let passwordTxt = passwordTextField.text, !passwordTxt.isValidString() {
                passwordErrorLabel.text = "Enter your password"
            }
            showErrorLabels()
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
            
            guard let accessToken = AccessToken.current else {
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
                                       "tokenSocialMedia": accessToken.tokenString
                    ]
                    
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.userLoginInService.signIn(params: userinfo.params, method: .post, url: loginWithFacebookURL) { (response, error) in
                            if let mappedResponse = response?.data
                            {
                                let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                                if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                    UIApplication.shared.keyWindow?.rootViewController = HomeVC
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            } else if error != nil {
                                //controller.handleError(error)
                            }
                        }
                        
                    }
                    //LocalStore.storeUserToken(token:accessToken.tokenString)
                    
                }
                //
                //                // Present the main view
                //                let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                //                if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                //                    self.navigationController?.pushViewController(HomeVC, animated: true)
                //                }
                
            })
            
        }
    }
    @IBAction func loginWithGoogleBtnAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        // GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    private func hideErrorLabels() {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    private func showErrorLabels() {
        emailErrorLabel.isHidden = false
        passwordErrorLabel.isHidden = false
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
                
                var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: loginWithFacebookURL, method: .post)
                //TODO .. replace email with google email
                userinfo.params = ["email": user?.authentication.idToken ,
                                   "password": googlePasswordConst,
                                   "tokenSocialMedia": token
                ]
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.userLoginInService.signIn(params: userinfo.params, method: .post, url: LoginWithGoogleURL) { (response, error) in
                        if let mappedResponse = response?.data
                        {
                            let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                            if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                UIApplication.shared.keyWindow?.rootViewController = HomeVC
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        } else if error != nil {
                            //controller.handleError(error)
                        }
                    }
                    
                }
                
                //                LocalStore.storeUserToken(token: token)
                //                let homeStoryboard = UIStoryboard(name: "Assets", bundle: nil)
                //                if let HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                //                    self.navigationController?.pushViewController(HomeVC, animated: true)
                //                }
            }
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
