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
    }
    
    func setup(_ asset: AssetModel) {
        
    } 
}
