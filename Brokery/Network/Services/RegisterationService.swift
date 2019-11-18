//
//  RegisterationService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

final class RegisterationService {
    private let client = WebClient(baseUrl: BaseAPIURL)
    
    @discardableResult
    func Register(forUser user: AccountDto, completion: @escaping ([AccountDto]?, ServiceError?) -> ()) -> URLSessionDataTask? {
        
        
        let params: JSON = ["user_email": user.email,
                            "user_password": user.password
                            ]
        
        return client.load(path: RegisterAccountURL, method: .post, params: params) { result, error in
            let dictionaries = result as? [JSON]
            completion(dictionaries?.compactMap(AccountDto.init), error)
        }
    }
}
