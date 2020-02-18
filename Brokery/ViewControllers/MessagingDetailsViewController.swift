//
//  MessagingDetailsViewController.swift
//  Brokery
//
//  Created by Sawy on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MessagingDetailsViewController: BaseViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        messagesTableView.register(UINib(nibName: "MassegeDetailsViewCell", bundle: nil), forCellReuseIdentifier: "MassegeDetailsViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getMeassagingList), for: UIControl.Event.valueChanged)
        messagesTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Messenger")
        getMeassagingList()
    }
    
    @objc func getMeassagingList() {
        //        massagingTableView.refreshControl?.endRefreshing()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
    }
}

extension MessagingDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassegeDetailsViewCell", for: indexPath) as? MassegeDetailsViewCell else {
            return UITableViewCell()
        }
        
        cell.setup()
        return cell
    }
}
