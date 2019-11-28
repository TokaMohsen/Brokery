//
//  RegisterAccount.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

struct UIAccountDto : Decodable {
    var email : String
    var password : String
    var mobile : String
    var name : String
    init(email : String , password : String , mobile : String , name : String) {
        self.email = email
        self.password = password
        self.mobile = mobile
        self.name = name
    }
}
