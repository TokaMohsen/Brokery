//
//  ServiceError.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/18/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}

extension ServiceError {
    typealias JSON = [String: Any]

    init(json: JSON) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}
