//
//  CreateChatMessageService.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/17/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
class CreateChatMessageService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (Bool?, WebError<CustomError>?) -> ())
    {
        let getListOfUserContactsTask: URLSessionDataTask!
        
        var userContactList = Resource< MsgObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userContactList.params = params
        
        getListOfUserContactsTask = MessagingDetailsViewController.sharedWebClient.load(resource: userContactList, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.success
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
