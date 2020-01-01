//
//  MarketPlaceViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class MarketPlaceViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var assetTableCustomView: AssetTable!
    
    private lazy var marketPlaceService = MarketPlaceService()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getAllAssetsTask: URLSessionDataTask!
    
    @IBAction func addAssetBtnAction(_ sender: UIButton) {
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
        getAllAssetsTask?.cancel()
        
        activityIndicator.startAnimating()
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: AuthentactionURL, method: .post)
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
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

