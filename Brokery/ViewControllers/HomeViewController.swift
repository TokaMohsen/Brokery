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
    var pageNunmber = 0
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
          let search = UISearchController(searchResultsController: nil)
          search.searchResultsUpdater = self
          search.obscuresBackgroundDuringPresentation = false
          search.searchBar.placeholder = "Type something here to search"
          navigationItem.searchController = search
          navigationItem.hidesSearchBarWhenScrolling = false
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          setupNavigationBar(title: "Home")
          pageNunmber = 0
          self.fetchData(withSearchText: nil)
      }
    
    @IBAction func addAssetBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AddAssetViewController" ) as? AddAssetViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func fetchData(withSearchText search: String?)
    {
        getFollowedDevelopersAssetsTask?.cancel()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: FollowedAssetsURL, method: .get)
        userinfo.params = ["Page": pageNunmber,
                           "PageSize": "10"]
        
        if let search = search {
            let filter = ["key": "Title", "value": search]
            userinfo.params["Filter"] = filter
        }
        
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
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func moveToLogin() {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
          guard let text = searchController.searchBar.text, text.count != 0 else { return }
          self.fetchData(withSearchText: text)
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
    
    func loadMore() {
        pageNunmber += 1
        self.fetchData(withSearchText: nil)
    }
}
