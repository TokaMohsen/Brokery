//
//  GetUsersListService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

class GetUsersListService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (UserObject?, WebError<CustomError>?) -> ())
    {
        let postGetUsersListTask: URLSessionDataTask!
        
        var userinfo = Resource< UserObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        postGetUsersListTask = AddAppointmentViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value
            {
                completion(response.value , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
