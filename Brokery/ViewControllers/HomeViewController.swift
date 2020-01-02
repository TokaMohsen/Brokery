//
//  HomeViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UISearchResultsUpdating {
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
                          
                        self.navigationController?.pushViewController(viewController, animated: true)
                      }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Home")
        
        self.fetchData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print("Test \(text)")
    }
    
    private func fetchData()
    {
        getFollowedDevelopersAssetsTask?.cancel()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
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
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
