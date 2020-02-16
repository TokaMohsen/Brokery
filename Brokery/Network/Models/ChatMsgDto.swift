//
//  ChatMsgDto.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/17/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
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
