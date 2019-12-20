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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

   
    private lazy var getUserInfoByTokenService = GetUserInfoByTokenService.init()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)

     var registerationTask: URLSessionDataTask!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //it should be move to home screen to get all user data
    fileprivate func getUserData(token : String)
    {
        if let accessToken = LocalStore.getUserToken(){
            self.getUserInfoByTokenService.fetch(errordelegate: self) { (data, error) in
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
 
  
    @IBAction func registerBtnAction(_ sender: UIButton) {
        if let emailTxt = emailTextField.text , let passwordTxt = passwordTextField.text , let mobileTxt = mobileNumberTextField.text , let fullname = fullNameTextField.text {
            
            registerationTask?.cancel()
            activityIndicator.startAnimating()
            
            var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: RegisterAccountURL, method: .post)
            
             let user =  userProfile.init(FullName: fullname)
            userinfo.params = ["email": emailTxt,
                               "password": passwordTxt,
                               "mobile": mobileTxt,
                               "name": emailTxt ,
                               "userProfile" : user]
            
            registerationTask = RegisterationViewController.sharedWebClient.load(resource: userinfo, urlMethod: .post) {[weak self] response in
                guard let controller = self else { return }
                DispatchQueue.main.async {
                    controller.activityIndicator.stopAnimating()
                    
                    if let mappedResponse = response.value?.data {
                        if let token = mappedResponse.token{
                            LocalStore.storeUserToken(token:token)
                        }
                        if let userId = mappedResponse.id {
                            LocalStore.storeUserID(id: userId)
                        }
                    } else if let error = response.error {
                        controller.handleError(error: error)
                    }
                }
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
