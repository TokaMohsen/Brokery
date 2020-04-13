//
//  RebsListTableCustomCell.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/8/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class RebsListTableCustomCell: UITableViewCell {
    @IBOutlet var followBtn: UIButton!
    
    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactNameLabelText: UILabel!
    @IBOutlet var jobTiteLabelText: UILabel!

    var rebsListTableCellDelegate : RebsListTableCellDelegateProtocol?
    var rebsListVC : RebsListViewController?
    var followBtnPressed = false
    
    override func awakeFromNib() {
    super.awakeFromNib()
    jobTiteLabelText.sizeToFit()
}
    @IBAction func followBtnAction(_ sender: UIButton) {
        self.followBtnPressed = !self.followBtnPressed
        if (self.followBtnPressed == true)
        {
            rebsListTableCellDelegate?.followContact()
        }
        else
        {
            rebsListTableCellDelegate?.unfollowContact()

        }
    }
    
    func setup(_ contact: UserDto , followBtnEnabled : Bool ) {
        contactNameLabelText.text = contact.name
        jobTiteLabelText.text = contact.email
        if let image = contact.userProfile?[0].photo
            {
                let url = URL(string: BaseAPIURL + image)
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                            if let image = image {
                                self.contactImage.image = image
                            }
                        })
                
            }
        self.updateFollowBtn(follow: followBtnEnabled)

    }
    
    func updateFollowBtn(follow: Bool) {
        let title = follow ? "Follow" : "Unfollow"
        DispatchQueue.main.async {
         self.followBtn.setTitle(title, for: .normal)
        }
    }
}
