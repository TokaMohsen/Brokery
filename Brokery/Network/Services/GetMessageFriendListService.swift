//
//  GetMessageFriendListService.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/12/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
class GetMessageFriendListService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (UserMessageObject?, WebError<CustomError>?) -> ())
    {
        let getListOfUserContactsTask: URLSessionDataTask!
        
        var userContactList = Resource< UserMessageObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userContactList.params = params
        
        getListOfUserContactsTask = MessagingListViewController.sharedWebClient.load(resource: userContactList, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
