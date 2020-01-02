//
//  MarketPlaceViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class MarketPlaceViewController: BaseViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var assetTableCustomView: AssetTable!
    
    private lazy var marketPlaceService = MarketPlaceService()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getAllAssetsTask: URLSessionDataTask!
    
    @IBAction func addAssetBtnAction(_ sender: UIButton) {
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
        setupNavigationBar(title: "Market Place")
        self.fetchData(withSearchText: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count != 0 else { return }
        self.fetchData(withSearchText: text)
    }
    
    private func fetchData(withSearchText search: String?)
    {
        getAllAssetsTask?.cancel()
        
        activityIndicator.startAnimating()
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: AllAssestsURL, method: .post)
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        if let search = search {
            let filter = ["key": "Title", "value": search]
            userinfo.params["Filter"] = filter
        }
        
        self.marketPlaceService.fetch(params: userinfo.params, method: .get, url: AllAssestsURL) { (response, error) in
            DispatchQueue.main.async {
                //            self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.stopAnimating()
            }

            if let mappedResponse = response?.data
            {
                self.assetTableCustomView.setupTableView(assets: mappedResponse)
                
            } else if error != nil {
                //controller.handleError(error)
            }
        }
        
        
    }
}

extension MarketPlaceViewController : AssetDelegateProtocol {
    func showDetailsOf(asset: AssetDto) {
        let storyboard = UIStoryboard(name: "Assets", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "AssetDetailsViewController") as? AssetDetailsViewController {
            viewController.getAssetModel(asset: asset)
            
            navigationController?.pushViewController(viewController, animated: true)
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

