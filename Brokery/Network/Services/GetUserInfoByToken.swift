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
    func fetch( errordelegate : HandleErrorDelegate ,completion: @escaping (UserDto?, ServiceError?) -> ()) -> URLSessionDataTask? {

//        return client.load(path: getUserInfoByTokenURL, method: .get, params: [:]) { result, error in
//            let dictionaries = result as? UserDto
//                //[JSON]
//            completion(dictionaries, error)
//        }
        return nil
    }
}

