//
//  RegisterationService.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/6/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
class RegisterationService {
    func register(params : JSON , method : RequestMethod , url : String , completion: @escaping (Object?, WebError<CustomError>?) -> ())
    {
        let postUserRegisterationInfoTask: URLSessionDataTask!
        
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userinfo.params = params
        
        postUserRegisterationInfoTask = RegisterationViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
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
