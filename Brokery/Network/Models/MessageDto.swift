//
// MessageDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct MessageDto: Codable {


    public var _id: String

    public var dateTime: Date

    public var body: String?

    public var toUserId: String

    public var fromUserId: String

    public var isDeleted: Bool

    public var fromUser: UserDto?

    public var toUser: UserDto?
    public init(_id: String, dateTime: Date, body: String?, toUserId: String, fromUserId: String, isDeleted: Bool, fromUser: UserDto?, toUser: UserDto?) { 
        self._id = _id
        self.dateTime = dateTime
        self.body = body
        self.toUserId = toUserId
        self.fromUserId = fromUserId
        self.isDeleted = isDeleted
        self.fromUser = fromUser
        self.toUser = toUser
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case dateTime
        case body
        case toUserId
        case fromUserId
        case isDeleted
        case fromUser
        case toUser
    }

}
