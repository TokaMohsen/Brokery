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
        let postGetUserAssetsTask: URLSessionDataTask!
        
        var userinfo = Resource<[String] , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        postGetUserAssetsTask = AddAppointmentViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
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
