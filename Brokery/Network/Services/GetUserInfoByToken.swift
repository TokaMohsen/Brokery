//
//  GetUserInfoByToken.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

final class GetUserInfoByTokenService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (UserProfileObject?, WebError<CustomError>?) -> ())
    {
        let postGetUsersListTask: URLSessionDataTask!
        
        var userinfo = Resource< UserProfileObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
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

