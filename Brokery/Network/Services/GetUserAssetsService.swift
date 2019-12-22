//
//  GetUserAssetsService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation


class GetUserAssetsService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([String]?, WebError<CustomError>?) -> ())
    {
        let getUserAssetsTask: URLSessionDataTask!
        
        var userinfo = Resource<[AssetDto] , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        getUserAssetsTask = AddAppointmentViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                let result = mappedResponse.compactMap({$0.title})
                completion(result , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
