//
//  ForgotPasswordService.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/6/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

//Email
//get
class ForgotPasswordService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (StatusObject?, WebError<CustomError>?) -> ())
    {
        let forgotPasswordTask: URLSessionDataTask!
        
        var userinfo = Resource<StatusObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        forgotPasswordTask = LoginViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                completion(nil , error)
            }
            
        }
    }
}
