//
//  AuthenticateService.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

class AuthenticateService : BaseModel  {
    
    private static var serviceSharedInstance: AuthenticateService = {
        let sharedService = AuthenticateService()
        
        return sharedService
    }()
    
    class func sharedInstance() -> AuthenticateService {
        return  serviceSharedInstance
    }
    
    typealias serviceCompletionBlock = (_ data: BaseModel?, _ error: Error?) -> Void
    var requestParameters: [String: Any]?
    func authenticate(completionBlock : @escaping serviceCompletionBlock) {
        LoginPostRequest.performAuthentication(parameters: [String : Any]) { (data, error) in
            if data != nil
            {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try JSONSerialization.data(withJSONObject: data as! NSDictionary, options: [])
                        let authResult = try decoder.decode(BaseModel.self, from: jsonData  )
                        completionBlock(authResult , error)
                        
                    } catch let error {
                        print("Error from JSON because: \(error.localizedDescription)")
                        return completionBlock(nil, error)
                    }
                    print(data)
                }
            }
            else
            {
                //handle error
                completionBlock(nil , error)
                
            }
        }
    }
    
}
