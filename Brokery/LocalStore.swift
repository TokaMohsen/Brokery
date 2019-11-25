//
//  LocalStore.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import UICKeyChainStore

class LocalStore {
    static func storeUserToken (token : String){
        UICKeyChainStore.setString(token, forKey: "application_token")
    }
    static func getUserToken()-> String? {
        if let token =  UICKeyChainStore.string(forKey: "application_token") {
            return token
        }
       return nil
    }
}
