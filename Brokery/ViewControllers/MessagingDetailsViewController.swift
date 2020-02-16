//
//  MessagingDetailsViewController.swift
//  Brokery
//
//  Created by Sawy on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MessagingDetailsViewController: BaseViewController {
    
    private lazy var createChatMessageService = CreateChatMessageService()

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var createMsgTask: URLSessionDataTask!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
//            massagingTableView.dataSource = self
//            massagingTableView.delegate = self
//            massagingTableView.register(UINib(nibName: "MassegeListViewCell", bundle: nil), forCellReuseIdentifier: "MassegeListViewCell")
//
//            let refreshControl = UIRefreshControl()
//            refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
//            refreshControl.addTarget(self, action: #selector(getMeassagingList), for: UIControl.Event.valueChanged)
//            massagingTableView.refreshControl = refreshControl
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setupNavigationBar(title: "Messenger")
            getMeassagingList()
        }
        
        @objc func getMeassagingList() {
    //        massagingTableView.refreshControl?.endRefreshing()
        }
}
