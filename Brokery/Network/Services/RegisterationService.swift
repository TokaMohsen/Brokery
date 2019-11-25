//
//  RegisterationService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import UICKeyChainStore

final class RegisterationService {
    private let client = WebClient(baseUrl: BaseAPIURL)
    
    @discardableResult
//    func Register(forUser user: UIAccountDto, errordelegate : HandleErrorDelegate ,completion: @escaping (UserDto?, ServiceError?) -> ()) -> URLSessionDataTask? {
//
//
//        let params: JSON = ["email": user.email,
//                            "password": user.password,
//                            "mobile" : user.mobile,
//                            "name" : user.email,
//                            ]
//
//        return client.load(path: RegisterAccountURL, method: .post, params: params) { result, error in
//
////            let decoder = JSONDecoder()
////            let jsonData = try JSONSerialization.data(withJSONObject: result as! NSDictionary, options: [])
//            let dictionaries = try decoder.decode(UserDto, from: jsonData  )
////
//            //let dictionaries = result as? UserDto
//                //[JSON]
////            if let mappedResult = result as? UserDto
////            {
//                if let token = dictionaries.token
//                {
//                    LocalStore.storeUserToken(token: token)
//                }
//            //}
//            completion(dictionaries, error)
//        }
//    }
    
    
    func Register (forUser user: UIAccountDto, errorDelegate : HandleErrorDelegate,completion: @escaping (UserLogin?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        
        let params: JSON = ["email": user.email,
                            "password": user.password,
                            "mobile" : user.mobile,
                            "name" : user.email,
                            ]
        
        return client.load(path: RegisterAccountURL, method: .post, params: params) { result, error in
            //let dictionaries = result as? UserLogin
//            let decoder = JSONDecoder()
//            let jsonData = try JSONSerialization.data(withJSONObject: result as! NSDictionary, options: [])
//            let dictionaries = try decoder.decode(UserLogin, from: jsonData  )
            let dictionaries = result as? UserLogin
            completion(dictionaries, error)
        }
    }
}
