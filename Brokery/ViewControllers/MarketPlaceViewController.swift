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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func fetchData()
    {
        getAllAssetsTask?.cancel()
        
        activityIndicator.startAnimating()
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: AuthentactionURL, method: .post)
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.marketPlaceService.fetch(params: userinfo.params, method: .get, url: AllAssestsURL) { (response, error) in
                if let mappedResponse = response?.data
                {
                    self.assetTableCustomView.setupTableView(assets: mappedResponse)

                } else if error != nil {
                    //controller.handleError(error)
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
