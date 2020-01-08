//
//  DropDownListsProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/4/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

protocol DropDownListsProtocol {
    func getUserListData(userList : [UserDto]?)
    func getUserAssetsData(assets: [AssetDto]?)
}
