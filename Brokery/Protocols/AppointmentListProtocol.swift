//
//  AppointmentListProtocol.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/29/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
protocol AppointmentListDelegateProtocol {
    func EditAppointment(appointment : AppointmentDto)
    func cancelAppointment(appointment : AppointmentDto)
    func getDevProfile(developer : UserDto)
}
