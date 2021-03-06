//
//  GetAllContactList.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/10/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
class GetAllContactListService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([UserDto]?, WebError<CustomError>?) -> ())
    {
        let getListOfUserContactsTask: URLSessionDataTask!
        
        var userContactList = Resource< UserObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userContactList.params = params
        
        getListOfUserContactsTask = RebsListViewController.sharedWebClient.load(resource: userContactList, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.data
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
