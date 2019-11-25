//
//  GetUserInfoByToken.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

final class GetUserInfoByTokenService {
    private let client = WebClient(baseUrl: BaseAPIURL)
    
    @discardableResult
    func fetch(forUser user: UIAccountDto, errordelegate : HandleErrorDelegate ,completion: @escaping (AccountDto?, ServiceError?) -> ()) -> URLSessionDataTask? {

        return client.load(path: getUserInfoByTokenURL, method: .get, params: [:]) { result, error in
            let dictionaries = result as? AccountDto
                //[JSON]
            completion(dictionaries, error)
        }
    }
}

