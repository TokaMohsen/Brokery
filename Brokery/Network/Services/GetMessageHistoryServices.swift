//
//  GetMessageHistoryServices.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/12/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation

class GetMessageHistoryServices {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([MessageHistoryObject]?, WebError<CustomError>?) -> ())
    {
        let getListOfMessagesTask: URLSessionDataTask!
        
        var userMessageList = Resource< [MessageHistoryObject] , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userMessageList.params = params
        
        getListOfMessagesTask = RebsListViewController.sharedWebClient.load(resource: userMessageList, urlMethod: method) {[weak self] response in
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
