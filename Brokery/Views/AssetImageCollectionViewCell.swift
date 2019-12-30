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

    @IBOutlet weak var assetImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        registerNibView()

        // Initialization code
    }
    
    func registerNibView() {
        let nib = UINib.init(nibName: String(describing: type(of: self)), bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        if let view = views[0] as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
   
    func setup(assetImagePath: String) {
        let url = URL(string: BaseAPIURL + assetImagePath)
        SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
            if image != nil {
                self.assetImage.image = image
            }
        })
    }
    
    func setup(image: UIImage) {
        self.assetImage.image = image
    }

}
