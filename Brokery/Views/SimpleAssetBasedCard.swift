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
    @IBOutlet weak var appartementName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var appartementDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibView()
        appartementDescription.sizeToFit()
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
    
}
