//
// FollowerDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct FollowerDto: Codable {


    public var _id: Int

    public var followerId: String

    public var followeeId: String

    public var isDeleted: Bool

    public var followee: UserDto?

    public var follower: UserDto?

    public var followerNavigation: UserDto?
    public init(_id: Int, followerId: String, followeeId: String, isDeleted: Bool, followee: UserDto?, follower: UserDto?, followerNavigation: UserDto?) { 
        self._id = _id
        self.followerId = followerId
        self.followeeId = followeeId
        self.isDeleted = isDeleted
        self.followee = followee
        self.follower = follower
        self.followerNavigation = followerNavigation
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case followerId
        case followeeId
        case isDeleted
        case followee
        case follower
        case followerNavigation
    }

}
