//
//  RegisterationViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/8/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class RegisterationViewController: BaseViewController {
    
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mobileNumberTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var accept = true
    private lazy var userRegisterationService = RegisterationService()
    
    @IBAction func acceptTermsBtnAction(_ sender: UIButton) {
        
        checkImage.isHighlighted = accept
        LocalStore.storeTermsConfirmation(confirm: accept)
        accept = !accept
    }
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var registerationTask: URLSessionDataTask!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        if let emailTxt = emailTextField.text , let passwordTxt = passwordTextField.text , let mobileTxt = mobileNumberTextField.text , let fullname = fullNameTextField.text {
            
            registerationTask?.cancel()
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: RegisterAccountURL, method: .post)
            
            let user =  UserProfileDto(id: nil, fullName: fullname, gender: nil, address: nil, photo: "testImage", createdBy: nil, createdAt: nil, updatedBy: nil, updatedAt: nil)
            
            userinfo.params = ["email": emailTxt,
                               "password": passwordTxt,
                               "mobile": mobileTxt,
                               "name": emailTxt]
            
            self.userRegisterationService.register(params: userinfo.params, method: .post, url: RegisterAccountURL) { (response, error) in
                if let mappedResponse = response?.data
                {
                    if let token = mappedResponse.token{
                        LocalStore.storeUserToken(token:token)
                    }
                    if let userId = mappedResponse.id {
                        LocalStore.storeUserID(id: userId)
                    }
                   
                }
                else if error != nil {
                    self.showErrorAlert(with: "server error ", title: "Error")
                }
                DispatchQueue.main.async {
                                       self.activityIndicator.stopAnimating()
                                   }
            }
        }
        
    }
    
    private func showErrorAlert(with message: String , title : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
