//
//  AssetHashtagCollectionViewCell.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/9/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AssetHashtagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var hashtagLabelText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        // Initialization code
    }
    
    func setup(hashtag: String) {
        self.hashtagLabelText.text = hashtag
    }
}
