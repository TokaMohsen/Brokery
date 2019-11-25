//
// HashTagsDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct HashTagsDto: Codable {


    public var _id: Int

    public var parentHashTagId: String

    public var childHashTagId: String

    public var isDeleted: Bool

    public var childHashTag: HashTagDto?

    public var parentHashTag: HashTagDto?
    public init(_id: Int, parentHashTagId: String, childHashTagId: String, isDeleted: Bool, childHashTag: HashTagDto?, parentHashTag: HashTagDto?) { 
        self._id = _id
        self.parentHashTagId = parentHashTagId
        self.childHashTagId = childHashTagId
        self.isDeleted = isDeleted
        self.childHashTag = childHashTag
        self.parentHashTag = parentHashTag
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case parentHashTagId
        case childHashTagId
        case isDeleted
        case childHashTag
        case parentHashTag
    }

}
