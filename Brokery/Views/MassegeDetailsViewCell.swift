//
//  MassegeDetailsViewCell.swift
//  Brokery
//
//  Created by Sawy on 2/14/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MassegeDetailsViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sentDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
    }
}
