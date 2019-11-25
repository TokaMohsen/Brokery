//
//  AssetTable.swift
//  Brokery
//
//  Created by Sawy on 11/23/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AssetTable: UIView {
    @IBOutlet weak var assetTableView: UITableView!
    var assets = [AssetModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assetTableView.dataSource = self
        assetTableView.delegate = self
        assetTableView.register(UINib(nibName: "AssetCard", bundle: nil), forCellReuseIdentifier: "AssetCard")
    }
    
    func setupTableView(assets: [AssetModel]) {
        self.assets = assets
        assetTableView.reloadData()
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
        return cell
    }
}

extension AssetTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
