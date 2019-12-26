//
//  CreateAppointmentService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/26/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

class CreateAppointmentService {
    func preformRequest(params : JSON , method : RequestMethod , url : String , completion: @escaping (AppointmentDto?, WebError<CustomError>?) -> ())
    {
        let postAppointmentTask: URLSessionDataTask!
        var appointmentInfo = Resource<AppointmentDto , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        appointmentInfo.params = params
        
        postAppointmentTask = AddAppointmentViewController.sharedWebClient.load(resource: appointmentInfo, urlMethod: method) {[weak self] response in
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
