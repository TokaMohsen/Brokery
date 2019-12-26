//
//  AppointmentProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/24/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

protocol AppointmentDelegateProtocol {
    func fetchUserListData() -> [String]?
    func fetchUserAssets(user_name : String)-> [String]?
}
