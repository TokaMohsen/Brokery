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
        self.layer.cornerRadius = 6
    }
    
    func setup(_ asset: AssetDto) {
       // appartementImage.image = asset.profilePhoto
        appartementName.text = asset.title
        appartementDescription.text = asset.description
        companyName.text = asset.owner?.name
        //for example
        if let tages = asset.tages{
            hashtag.text = tages[0]
        }
    }
    private func setupHashtag(tages : [String])
    {
        if tages.count > 2 {
            hashtag.text = tages[0]
                //var array = tages[0].componentsSeparatedByString("\r")

        }
    }
}
