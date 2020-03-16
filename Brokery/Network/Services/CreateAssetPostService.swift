//
//  CreateAssetPostService.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/2/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

class CreateAssetPostService {
    func post(params : JSON , method : RequestMethod , url : String , completion: @escaping (PostObject?, WebError<CustomError>?) -> ())
    {
        let postUserLoginInfoTask: URLSessionDataTask!
        
        var userinfo = Resource<PostObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userinfo.params = params
        //senf file in data not array of bytes
        postUserLoginInfoTask = LoginViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                    completion(mappedResponse , nil)
                
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
