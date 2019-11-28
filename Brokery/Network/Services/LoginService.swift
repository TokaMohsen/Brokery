//
//  LoginService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/28/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

class LoginService {
    func signIn(params : JSON , method : RequestMethod , url : String , completion: @escaping (Object?, WebError<CustomError>?) -> ())
    {
        let postUserLoginInfoTask: URLSessionDataTask!
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userinfo.params = params
        
        postUserLoginInfoTask = LoginViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.data
            {
                if let token = mappedResponse.token{
                    LocalStore.storeUserToken(token:token)
                    completion(response.value , nil)
                }
                
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
