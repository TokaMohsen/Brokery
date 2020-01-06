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
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "application_token")
        defaults.synchronize()
        
       // UICKeyChainStore.setString(token, forKey: "application_token")
    }
    static func getUserToken()-> String? {
//        if let token =  UICKeyChainStore.string(forKey: "application_token") {
//            return token
//        }
//
//       return nil
        
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "application_token")
        {
            return token
        }
        return nil 
    }
    
    static func deleteUserToken(){
        UserDefaults.standard.removeObject(forKey: "application_token")
    }
     
    static func storeUserID (id : String){
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "application_id")
        defaults.synchronize()
        
        // UICKeyChainStore.setString(token, forKey: "application_token")
    }
    
    static func getUserId()-> String? {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "application_id")
        {
            return token
        }
        return nil
    }
    
    static func deleteUserId (){
        UserDefaults.standard.removeObject(forKey: "application_id")
    }
    
    
    static func storeTermsConfirmation (confirm : Bool){
        let defaults = UserDefaults.standard
        defaults.set(confirm, forKey: "confirm_user")
        defaults.synchronize()
    }
    
    static func getTermsConfirmation()-> Bool? {
        let defaults = UserDefaults.standard
        return  defaults.bool(forKey: "confirm_user")
    }
    
    static func deleteTermsConfirmation (){
        UserDefaults.standard.removeObject(forKey: "confirm_user")
    }
}
