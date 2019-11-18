//
//  Authentication.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/13/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

struct UserLogin : Codable{
    var email : String?
    var password : String?
}
extension UserLogin {
    init?(json: JSON) {
        guard let email = json["email"] as? String else {
            return nil
        }
        guard let password = json["password"] as? String else {
            return nil
        }
        self.email = email
        self.password = password
    }
}
