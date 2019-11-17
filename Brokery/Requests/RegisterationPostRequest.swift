//
//  RegisterationPostRequest.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import AFNetworking

class RegisterationPostRequest {
    
    
    typealias requestCompletionBlock = (_ data: Any?, _ error: Error?) -> Void
    
    static func performRegisteration(parameters: [String: Any] , completionblock : @escaping requestCompletionBlock){
        let manager = AFHTTPSessionManager()
        manager.post( BaseAPIURL+RegisterAccountURL,
                      parameters: parameters,
                      progress: nil,
                      success:
            {
                (operation, responseObject) in
                
                if let dic = responseObject  {
                    completionblock(dic, nil)
                }
        },
                      failure:
            {
                (operation, error) in
                completionblock(nil , error)
                print("Error: " + error.localizedDescription)
        })}
}
