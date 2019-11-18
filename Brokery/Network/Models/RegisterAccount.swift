//
//  RegisterAccount.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

struct AccountDto : Codable{
    var email : String
    var password : String
    var mobile : String?
}
extension AccountDto {
    init?(json: JSON) {
        guard let email = json["email"] as? String else {
            return nil
        }
        guard let password = json["password"] as? String else {
            return nil
        }
        self.email = email
        self.password = password
        self.mobile = json["mobile"] as? String
    }
}
