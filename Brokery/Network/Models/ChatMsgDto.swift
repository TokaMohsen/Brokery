//
//  ChatMsgDto.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/17/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation


public struct MsgObject: Decodable {
    var success: Bool
    var data: ChatMsgDto?
    var count: Int?
    var code: String?
    
}
public struct ChatMsgDto : Decodable
{
    public var id: String?
    public var dateTime: String?
    public var body: String?
    public var accountId: String?
    public var toUserId: String?
    public var fromUserId: String?
    public var isDeleted: Bool?
    public var account: AccountDto?
    public var fromUser: UserDto?
    public var toUser: UserDto?
    public var type: Int?

}

public struct msgDto : Decodable
{
    public var downloadUrl: String?
    public var message: String?
    public var toId: String?
    public var fromId: String?
    public var dateSent: String?
    public var dateSeen: String?
    public var isDeleted: Bool?
    public var type: Int?
    public var fileSizeInBytes: Int?

}
//"type": 0,
//"fromId": "1dd71bb1-a1bb-4aba-814f-e58b794285bc",
//"toId": "0af31937-4612-4144-9680-4c9f26f882fd",
//"message": "Hello Again",
//"dateSent": "2020-02-04T22:56:08.885",
//"dateSeen": "0001-01-01T00:00:00",
//"downloadUrl": null,
//"fileSizeInBytes": 0,
