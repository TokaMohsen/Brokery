//
//  AssetProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/12/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

protocol AssetDelegateProtocol {
    func showDetailsOf(asset : AssetDto)
    func loadMore()
}
