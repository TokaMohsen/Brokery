//
// UserDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public struct UserObject: Decodable {
    var success: Bool
    var data: [UserDto]?
    var count: Int?
    var code: String?
    
}
public struct UserMessageObject: Decodable {
    var success: Bool
    var data: [UserDtoMessageObject]?
    var count: Int?
    var code: String?
    
}

public class UserDtoMessageObject: Decodable {
    
    public var id: String?
    
    public var name: String?
    
    public var email: String?
    public var mobile: String?
    
    public var password: String?
    
    public var userTypeId: Int?
    
    public var accountId: String?
    
    public var userProfileId: String?
    
    public var isSuperAdmin: Bool?

    public var isAdmin: Bool?

    public var isActive: Bool?

    public var isDeleted: Bool?

    public var createdBy: String?

    public var createdAt: String?

    public var updatedBy: String?
    public var updatedAt: String?
    //public var account: [AccountDto]?
   // public var userProfile: [UserProfileDto]?
    public var userType: [UserTypeDto]?
    public var assetGalleryIdNavigation: [AssetGalleryDto]?
    public var accountAdmin: [AccountDto]?
    public var appointmentBroker: [AppointmentDto]?
    public var appointmentCustomer: [AppointmentDto]?
    public var appointmentDeveloper: [AppointmentDto]?
    public var assetOwner: [AssetDto]?
    public var contactBroker: [ContactDto]?
    public var contactCustomer: [ContactDto]?

    public var followee: [FollowerDto]?

    public var follower: [FollowerDto]?

    public var followerFollowerNavigation: [FollowerDto]?

    public var messageFromUser: [MessageDto]?

    public var messageToUser: [MessageDto]?

    public var notificationFromUser: [NotificationDto]?

    public var notificationToUser: [NotificationDto]?

    public var userGroupUser: [UserGroupUserDto]?

    public var userHashTag: [UserHashTagDto]?
    public var token: String?
}

public class UserDto: Decodable {
    
    public var id: String?

    public var name: String?

    public var email: String?

    public var mobile: String?

    public var password: String?

    public var userTypeId: Int?

    public var accountId: String?

    public var userProfileId: String?

    public var isSuperAdmin: Bool?

    public var isAdmin: Bool?

    public var isActive: Bool?

    public var isDeleted: Bool?

    public var createdBy: String?

    public var createdAt: String?

    public var updatedBy: String?
    public var updatedAt: String?
    public var account: [AccountDto]?
    public var userProfile: [UserProfileDto]?
    public var userType: [UserTypeDto]?
    public var assetGalleryIdNavigation: [AssetGalleryDto]?
    public var accountAdmin: [AccountDto]?
    public var appointmentBroker: [AppointmentDto]?
    public var appointmentCustomer: [AppointmentDto]?
    public var appointmentDeveloper: [AppointmentDto]?
    public var assetOwner: [AssetDto]?
    public var contactBroker: [ContactDto]?

    public var contactCustomer: [ContactDto]?

    public var followee: [FollowerDto]?

    public var follower: [FollowerDto]?

    public var followerFollowerNavigation: [FollowerDto]?

    public var messageFromUser: [MessageDto]?

    public var messageToUser: [MessageDto]?

    public var notificationFromUser: [NotificationDto]?

    public var notificationToUser: [NotificationDto]?

    public var userGroupUser: [UserGroupUserDto]?

    public var userHashTag: [UserHashTagDto]?
    public var token: String?

   
}


public struct UserProfileObject: Decodable {
    var success: Bool
    var data: UserResultDto?
    var count: Int?
    var code: String?
    
}

public class UserResultDto: Decodable {


    public var id: String?

    public var name: String?

    public var email: String?

    public var mobile: String?

    public var password: String?

    public var userTypeId: Int?

    public var accountId: String?

    public var userProfileId: String?

    public var isSuperAdmin: Bool?

    public var isAdmin: Bool?

    public var isActive: Bool?

    public var isDeleted: Bool?

    public var createdBy: String?

    public var createdAt: String?

    public var updatedBy: String?
    public var updatedAt: String?
    public var account: [AccountDto]?
    public var userProfile: UserProfileDto?
    public var userType: [UserTypeDto]?
    public var assetGalleryIdNavigation: [AssetGalleryDto]?
    public var accountAdmin: [AccountDto]?
    public var appointmentBroker: [AppointmentDto]?
    public var appointmentCustomer: [AppointmentDto]?
    public var appointmentDeveloper: [AppointmentDto]?
    public var assetOwner: [AssetDto]?
    public var contactBroker: [ContactDto]?

    public var contactCustomer: [ContactDto]?

    public var followee: [FollowerDto]?

    public var follower: [FollowerDto]?

    public var followerFollowerNavigation: [FollowerDto]?

    public var messageFromUser: [MessageDto]?

    public var messageToUser: [MessageDto]?

    public var notificationFromUser: [NotificationDto]?

    public var notificationToUser: [NotificationDto]?

    public var userGroupUser: [UserGroupUserDto]?

    public var userHashTag: [UserHashTagDto]?
    public var token: String?
    public var tokenSocialMedia : String?

   
}
