//
// AssetTypeStatus.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct AssetTypeStatus: Codable {


    public var _id: Int

    public var isActive: Bool
    public init(_id: Int, isActive: Bool) { 
        self._id = _id
        self.isActive = isActive
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case isActive
    }

}
