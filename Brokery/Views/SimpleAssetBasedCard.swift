//
//  SimpleAssetBasedCard.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class SimpleAssetBasedCard: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var appartementName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var appartementDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerNibView()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        registerNibView()
    }
    
    func registerNibView() {
        Bundle.main.loadNibNamed("SimpleAssetBasedCard", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setup(_ asset: AssetDto) {
       // appartementImage.image = asset.profilePhoto
        appartementName.text = "Home Asset title"
            //asset.title
        appartementDescription.text = "asset description of two line has been setted previously static asset description of two line has been setted previously static asset description of two line has been setted previously static"
            //asset.description
        companyName.text = "toqa mohsen"
            //asset.owner?.name
        jobTitle.text = "developer"
            //asset.owner?.userProfile?.description
        
        appartementDescription.sizeToFit()
     
    }
    
}
