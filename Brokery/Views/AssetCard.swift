//
//  AssetCard.swift
//  Brokery
//
//  Created by Sawy on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AssetCard: UITableViewCell {
    @IBOutlet weak var appartementImage: UIImageView!
    @IBOutlet weak var appartementName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var hashtag: UILabel!
    @IBOutlet weak var appartementDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        appartementDescription.sizeToFit()
    }
    
    func setup(_ asset: AssetDto) {
       // appartementImage.image = asset.profilePhoto
        appartementName.text = asset.title
        appartementDescription.text = asset.description
        companyName.text = asset.owner?.name
        jobTitle.text =  asset.owner?.mobile
        if let tages = asset.tages{
            setupHashtag(tages : tages)
        }
        else
        {
            setupHashtag(tages: ["new" , "tag" , "explore"] )
        }
        
    }
    private func setupHashtag(tages : [String])
    {
        hashtag.lineBreakMode = .byWordWrapping
        if tages.count > 2 {
            let hashtagStr = "#" + tages[0] + "\n" + "#" + tages[1] + "\n" + "+" + String ((tages.count - 2)) + " tages"
            hashtag.text = hashtagStr
        }
        else if tages.count > 1
        {
            let hashtagStr = tages[0] + "\n" + tages[1]
             hashtag.text = hashtagStr
        }
        else
        {
            let hashtagStr = tages[0]
             hashtag.text = hashtagStr
        }
    }
}
