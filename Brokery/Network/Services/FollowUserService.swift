//
//  FollowUserService.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

class FollowUserService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (Bool, WebError<CustomError>?) -> ())
    {
        let postFollowUserTask: URLSessionDataTask!
        
        var userinfo = Resource<StatusObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userinfo.params = params
        
        postFollowUserTask = RebsListViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.data
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(false , response.error)
            }
            
        }
    }
}
