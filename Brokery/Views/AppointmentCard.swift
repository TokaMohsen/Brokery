//
//  AppointmentCard.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/29/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import iOSDropDown

class AppointmentCard: UITableViewCell {
    
    let goldcolor = UIColor(red: 239/255, green: 180/255, blue: 28/255, alpha: 1)

    var AppointmentListDelegate : AppointmentListDelegateProtocol?

    @IBOutlet var appointmentTimeLabelText: UILabel!
    
    @IBOutlet var titleLabelText: UILabel!
    
    @IBOutlet var descriptionLabelText: UILabel!
    
    @IBOutlet var colorMarkView: UIView!
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        let options = ["Edit" , "Cancle" , "Dev Profile"]
//        chooseDeveloperDropDown.optionArray = options
//               chooseDeveloperDropDown.didSelect { (selectedItem, index, id) in
//                //AppointmentListDelegate?.cancelAppointment(appointment: <#T##AppointmentDto#>)
//               }
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
    //descriptionLabelText.sizeToFit()
}

    func setup(_ appointment: AppointmentDto , coloredCard : Bool) {
        appointmentTimeLabelText.text = appointment.dateTime
        if let brokerName = appointment.broker?.userProfile?.fullName , let contactName = appointment.contact?.fullName , let developerName = appointment.developer?.userProfile?.fullName
        {
            titleLabelText.text = brokerName + " +" + contactName + " +" + developerName
        }
        else
        {
             titleLabelText.text = "Title"
        }
        if let description = appointment.description
        {
          descriptionLabelText.text = description
        }
        else
        {
            descriptionLabelText.text  = "Description"
        }
        colorMarkView.backgroundColor = coloredCard ? goldcolor : UIColor.black
    }
}
