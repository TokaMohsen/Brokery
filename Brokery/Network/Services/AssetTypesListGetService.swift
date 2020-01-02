//
//  AssetTypesListGetService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/11/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
class AssetTypesListGetService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([AssetType]?, WebError<CustomError>?) -> ())
    {
        let postUserLoginInfoTask: URLSessionDataTask!
        
        var userinfo = Resource<AssetTypeObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        AddAssetViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.data
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
