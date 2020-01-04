//
//  AppointmentProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/24/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

protocol AppointmentDelegateProtocol {
    func fetchUserListData() -> [UserDto]?
    func fetchUserAssets(user_id : String) -> [AssetDto]?
}
