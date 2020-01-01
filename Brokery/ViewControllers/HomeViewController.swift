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
    
    @IBOutlet var assetTableCustomView: AssetTable!
    
    private lazy var homeService = HomeService()
    private var assetModel: AssetDto?
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)

    var getFollowedDevelopersAssetsTask: URLSessionDataTask!
    
    @IBAction func addAssetBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
                      if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAssetViewController" ) as? AddAssetViewController {
                         // viewController
                          
                          navigationController?.pushViewController(viewController, animated: true)
                      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func fetchData()
    {
        getFollowedDevelopersAssetsTask?.cancel()
        
        activityIndicator.startAnimating()
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: AuthentactionURL, method: .post)
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        self.homeService.fetch(params: userinfo.params, method: .get, url: FollowedAssetsURL) { (response, error) in
            DispatchQueue.main.async {
                //            self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.stopAnimating()
            }
            
            if let mappedResponse = response?.data
            {
                self.assetTableCustomView.setupTableView(assets: mappedResponse)
                self.assetTableCustomView.assetDelegate = self
                
            } else if error != nil {
                //controller.handleError(error)
                self.showErrorAlert(with: "error")
            }
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let filteredMovieList = self.filteredMovieList
    //        {
    //            detailsVc.getFilteredData(movieList: filteredMovieList)
    //        }
    //    }
    
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
     Get the new view controller using segue.destination.
     Pass the selected object to the new view controller.
     }
     */
    
}

extension HomeViewController : AssetDelegateProtocol {
    func showDetailsOf(asset: AssetDto) {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AssetDetailsViewController") as? AssetDetailsViewController {
            viewController.getAssetModel(asset: asset)
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
