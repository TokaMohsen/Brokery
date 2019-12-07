//
//  MarketPlaceService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/1/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
class MarketPlaceService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (AssetObject?, WebError<CustomError>?) -> ())
    {
        let postUserLoginInfoTask: URLSessionDataTask!
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        postUserLoginInfoTask = MarketPlaceViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                 completion(response.value , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
