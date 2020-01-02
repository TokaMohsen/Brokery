//
//  GetListOfUserContactsService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/26/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation


class GetListOfUserContactsService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([Contact]?, WebError<CustomError>?) -> ())
    {
        let getListOfUserContactsTask: URLSessionDataTask!
        
        var userContactList = Resource< ContactList , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userContactList.params = params
        
        getListOfUserContactsTask = AddAppointmentViewController.sharedWebClient.load(resource: userContactList, urlMethod: method) {[weak self] response in
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
