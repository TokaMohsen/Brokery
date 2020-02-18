//
//  MassegeListViewCell.swift
//  Brokery
//
//  Created by Sawy on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MassegeListViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(user : UserDto) {
        self.selectionStyle = .none
        self.name.text = user.name
        self.jobTitle.text = user.email
    }
}
