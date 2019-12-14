//
//  AssetTable.swift
//  Brokery
//
//  Created by Sawy on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import SDWebImage

class AssetTable: UIView {
    @IBOutlet weak var assetTableView: UITableView!
    var assets = [AssetDto]()
    var assetDelegate : AssetDelegateProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibView()
        assetTableView.dataSource = self
        assetTableView.delegate = self
        assetTableView.register(UINib(nibName: "AssetCard", bundle: nil), forCellReuseIdentifier: "AssetCard")
    }
    
    func setupTableView(assets: [AssetDto]) {
        self.assets = assets
        DispatchQueue.main.async {
            self.assetTableView.reloadData()
        }
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

extension AssetTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCard", for: indexPath) as? AssetCard else {
            return UITableViewCell()
        }
        
        cell.setup(assets[indexPath.row])
        if let img  = assets[indexPath.row].photo {
            if img.isEmpty{
                cell.appartementImage.image = UIImage(named: "testImage")
            }
            else{
                let url = URL(string: BaseAPIURL + img)
                SDWebImageManager.shared().imageDownloader?.downloadImage(with:url , options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                    if image != nil {
                        cell.appartementImage.image = image
                    }
                })
            }
        }
        return cell
    }
}

extension AssetTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        assetDelegate?.showDetailsOf(asset: self.assets[indexPath.row])

    }
}
