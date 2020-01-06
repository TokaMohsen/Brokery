//
//  MapProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/11/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

protocol MapDelegateProtocol {
    func updateAssetDetailsLocation(assetLocation : CLLocationCoordinate2D)
    func updateAddAssetLocation(assetLocation : String)

}

