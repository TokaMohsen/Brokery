//
//  AddAppointmentViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AddAppointmentViewController: UIViewController {

    private lazy var usersListService = GetUsersListService()
    private lazy var userAssetsService = GetUserAssetsService()

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getAllUsersTask: URLSessionDataTask!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    private func fetchData()
    {
        getAllUsersTask?.cancel()
        
       // activityIndicator.startAnimating()
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUsersListURL, method: .post)
       
        DispatchQueue.main.async {
            self.usersListService.fetch(params: userinfo.params, method: .get, url: getUsersListURL) { (response, error) in
                if let mappedResponse = response?.data
                {
                   //getUserAssetsURL
                    
                } else if error != nil {
                    //controller.handleError(error)
                    self.showErrorAlert(with: "error")
                }
            }
          //  self.activityIndicator.stopAnimating()
            
            
        }
        
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
