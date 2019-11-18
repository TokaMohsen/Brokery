//
//  BaseModel.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
typealias JSON = [String: Any]

public  class BaseModel : Codable {

    var success: Bool?
    var code: String?
    var count: Int?
    var result: String?

}
