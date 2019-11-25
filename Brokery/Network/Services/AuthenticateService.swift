//
//  AuthenticateService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import UICKeyChainStore

final class AuthenticateService {
    private let client = WebClient(baseUrl: BaseAPIURL)
    
    @discardableResult
    func authenticate (forUser user: UIUserLogin, errorDelegate : HandleErrorDelegate,completion: @escaping (UserLogin?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        
        let params: JSON = ["email": user.email,
                            "password": user.password
        ]
        
        return client.load(path: AuthentactionURL, method: .post, params: params) { result, error in
            let dictionaries = result as? UserLogin
            completion(dictionaries, error)
        }
    }
}
