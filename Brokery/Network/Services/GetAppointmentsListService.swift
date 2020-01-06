//
//  GetAppointmentsListService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/30/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

class GetAppointmentsListService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping ([AppointmentDto]?, WebError<CustomError>?) -> ())
    {
        let getAppointmentListTask: URLSessionDataTask!
        
        var userinfo = Resource<AppointmentListObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .get)
        userinfo.params = params
        
        getAppointmentListTask = AppointmentsListViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
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
