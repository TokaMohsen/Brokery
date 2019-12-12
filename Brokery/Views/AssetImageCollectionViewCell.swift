//
//  AssetImageCollectionViewCell.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/9/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import SDWebImage

class AssetImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var assetImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6

        // Initialization code
    }
   
    func setup(assetImagePath: String) {
        let url = URL(string: BaseAPIURL + assetImagePath)
        SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
            if image != nil {
                self.assetImageView.image = image
            }
        })

    }

}
