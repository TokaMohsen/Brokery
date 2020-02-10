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

    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var contactNameLabelText: UILabel!
    @IBOutlet var jobTiteLabelText: UILabel!

    override func awakeFromNib() {
    super.awakeFromNib()
    jobTiteLabelText.sizeToFit()
}
    @IBAction func followBtnAction(_ sender: UIButton) {
    }
    
    func setup(_ contact: ContactDto ) {
        contactNameLabelText.text = contact.fullName
        jobTiteLabelText.text = contact.email
        if let image = contact.photo
            {
                let url = URL(string: BaseAPIURL + image)
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                            if let image = image {
                                self.contactImage.image = image
                            }
                        })
                
            }

    }
}
