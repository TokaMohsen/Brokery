//
//  AuthenticateService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

final class AuthenticateService {
    private let client = WebClient(baseUrl: BaseAPIURL)
    
    @discardableResult
    func authenticate (forUser user: UserLogin, errorDelegate : HandleErrorDelegate,completion: @escaping ([UserLogin]?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        
        let params: JSON = ["user_email": user.email,
                            "user_password": user.password
        ]
        
        return client.load(path: AuthentactionURL, method: .post, params: params) { result, error in
            let dictionaries = result as? [JSON]
            completion(dictionaries?.compactMap(UserLogin.init), error)
        }
    }
}
