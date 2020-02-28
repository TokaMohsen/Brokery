//
//  MassegeDetailsViewCell.swift
//  Brokery
//
//  Created by Sawy on 2/14/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MassegeDetailsViewCell: UITableViewCell {
    
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sentDate: UILabel!
    
    @IBOutlet weak var reversedTrailing: NSLayoutConstraint!
    @IBOutlet weak var defaultTrailing: NSLayoutConstraint!
    @IBOutlet weak var reversedLeading: NSLayoutConstraint!
    @IBOutlet weak var defaultLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageContainerView.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        messageContainerView.layer.borderWidth = 1
        messageContainerView.layer.cornerRadius = 20
    }
    
    func setup(message: msgDto) {
        
        let isMine = message.fromId == LocalStore.getUserId()
        if isMine {
            messageContainerView.backgroundColor = UIColor.white
            
            reversedLeading.priority = .defaultHigh
            reversedTrailing.priority = .defaultHigh
            defaultLeading.priority = .defaultLow
            defaultTrailing.priority = .defaultLow
            
        } else {
            messageContainerView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
            
            defaultLeading.priority = .defaultHigh
            defaultTrailing.priority = .defaultHigh
            reversedLeading.priority = .defaultLow
            reversedTrailing.priority = .defaultLow
        }
        
        messageLabel.text = message.message
        sentDate.text = message.dateSent
//        avatar.image =
    }
}
