//
//  HomeViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private lazy var homeService = HomeService()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getFollowedDevelopersAssetsTask: URLSessionDataTask!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        // Do any additional setup after loading the view.
    }
    
    private func fetchData()
    {
        getFollowedDevelopersAssetsTask?.cancel()
        
        activityIndicator.startAnimating()
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: AuthentactionURL, method: .post)
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.homeService.fetch(params: userinfo.params, method: .get, url: FollowedAssetsURL) { (response, error) in
                if let mappedResponse = response?.title
                {
                   
                    
                } else if error != nil {
                    //controller.handleError(error)
                }
            }
            
        }

    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
//    
//    override func handleError(_ error: WebError<CustomError>) {
//        switch error {
//        case .noInternetConnection:
//            showErrorAlert(with: "The internet connection is lost")
//        case .unauthorized:
//            moveToLogin()
//        case .other:
//            showErrorAlert(with: "Unfortunately something went wrong")
//        case .custom(let error):
//            showErrorAlert(with: error.message)
//        }
//    }
    
    private func moveToLogin() {
        
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
