//
// NotificationDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct NotificationDto: Codable {


    public var _id: String

    public var dateTime: Date

    public var message: String?

    public var toUserId: String?

    public var fromUserId: String?

    public var assetId: String?

    public var isDeleted: Bool

    weak var asset: AssetDto?

    weak var fromUser: UserDto?

    public var toUser: UserDto?
    public init(_id: String, dateTime: Date, message: String?, toUserId: String?, fromUserId: String?, assetId: String?, isDeleted: Bool, asset: AssetDto?, fromUser: UserDto?, toUser: UserDto?) { 
        self._id = _id
        self.dateTime = dateTime
        self.message = message
        self.toUserId = toUserId
        self.fromUserId = fromUserId
        self.assetId = assetId
        self.isDeleted = isDeleted
        self.asset = asset
        self.fromUser = fromUser
        self.toUser = toUser
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case dateTime
        case message
        case toUserId
        case fromUserId
        case assetId
        case isDeleted
        case asset
        case fromUser
        case toUser
    }

}
