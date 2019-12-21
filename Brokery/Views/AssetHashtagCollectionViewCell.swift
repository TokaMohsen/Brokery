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
    
    func setup(hashtag: String) {
        self.hashtagLabelText.text = hashtag
    }
}
