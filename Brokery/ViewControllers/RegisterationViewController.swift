//
//  RegisterationViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/8/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import SafariServices

class RegisterationViewController: BaseViewController {
    
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var fullNameErrorlabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    
    @IBOutlet weak var acceptTermsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isTermsAccepted = false
    private lazy var userRegisterationService = RegisterationService()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    let termsURL = "https://www.google.com"
    var registerationTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAcceptButtonImage()
        hideErrorsLabel()
        
        fullNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        mobileNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        setupNavigationBar(title: "")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        hideErrorsLabel()
    }
    
    @IBAction func acceptTermsBtnAction(_ sender: UIButton) {
        LocalStore.storeTermsConfirmation(confirm: isTermsAccepted)
        isTermsAccepted = !isTermsAccepted
        setAcceptButtonImage()
    }
    
    @IBAction func showTermsWebView(_ sender: UIButton) {
        if let url = URL(string: termsURL) {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    private func setAcceptButtonImage() {
        let imageString = isTermsAccepted ? "filledCheckBox" : "emptyCheckBox"
        acceptTermsButton.setImage(UIImage(named: imageString), for: .normal)
    }
    
    fileprivate func navigateToLogin() {
        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        if !isValidInput() {
            return
        }
        
        if let fullName = fullNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text,
            let mobile = mobileNumberTextField.text {
            
            registerationTask?.cancel()
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: RegisterAccountURL, method: .post)
            
            let user =  UserProfileDto(id: nil, fullName: fullName, gender: nil, address: nil, photo: "testImage", createdBy: nil, createdAt: nil, updatedBy: nil, updatedAt: nil)
            
            userinfo.params = ["email": email,
                               "password": password,
                               "mobile": mobile,
                               "name": fullName]
            
            self.userRegisterationService.register(params: userinfo.params, method: .post, url: RegisterAccountURL) { (response, error) in
                if let mappedResponse = response?.data
                {
                    if let token = mappedResponse.token{
                        LocalStore.storeUserToken(token:token)
                        self.navigateToLogin()
                    }
                    if let userId = mappedResponse.id {
                        LocalStore.storeUserID(id: userId)
                    }
                   
                }
                else if error != nil {
                    self.showErrorAlert(with: "server error", title: "Error")
                }
                DispatchQueue.main.async {
                                       self.activityIndicator.stopAnimating()
                                   }
            }
        }
        
    }

    private func hideErrorsLabel() {
        fullNameErrorlabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmPasswordErrorLabel.isHidden = true
        mobileErrorLabel.isHidden = true
    }
    
    private func isValidInput() -> Bool{
        
        var isValid = true
        if let fullName = fullNameTextField.text, !fullName.isValidString() {
            fullNameErrorlabel.isHidden = false
            isValid = false
        }
        
        if let email = emailTextField.text, !email.isValidEmail() {
            emailErrorLabel.isHidden = false
            isValid = false
        }
        
        if let password = passwordTextField.text, !password.isValidString() {
            passwordErrorLabel.isHidden = false
            isValid = false
        }
        
        if let confirmPassword = confirmPasswordTextField.text, (!confirmPassword.isValidString() || passwordTextField.text != confirmPassword) {
            confirmPasswordErrorLabel.isHidden = false
            isValid = false
        }
        
        if let mobile = mobileNumberTextField.text, !mobile.isValidMobileNumber() {
            mobileErrorLabel.isHidden = false
            isValid = false
        }
        
        if !isTermsAccepted && isValid {
            showErrorAlert(with: "Please accept terms and condition", title: "")
            isValid = false
        }
        
        return isValid
    }
}
