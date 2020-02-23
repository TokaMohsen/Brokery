//
// UserGroupDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public class UserGroupDto: Decodable {


    public var id: String?

    public var name: String?

    public var description: String?

    public var isActive: Bool

    public var isDeleted: Bool

    public var userGroupPrivilege: [UserGroupPrivilegeDto]?

    public var userGroupUser: [UserGroupUserDto]?
}
