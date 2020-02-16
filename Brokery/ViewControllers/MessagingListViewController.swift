//
//  MessagingListViewController.swift
//  Brokery
//
//  Created by Sawy on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MessagingListViewController: BaseViewController {
    
    @IBOutlet weak var massagingTableView: UITableView!
    
    
    var contacts = [UserDto]()

    private lazy var messageFriendListService = GetMessageFriendListService()

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getContactListTask: URLSessionDataTask!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        massagingTableView.dataSource = self
        massagingTableView.delegate = self
        massagingTableView.register(UINib(nibName: "MassegeListViewCell", bundle: nil), forCellReuseIdentifier: "MassegeListViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getMeassagingList), for: UIControl.Event.valueChanged)
        massagingTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Messenger")
        getMeassagingList()
    }
    
    @objc func getMeassagingList() {
        var userinfo = Resource< GetContactsObject , CustomError>(jsonDecoder: JSONDecoder(), path: getFriendListURL, method: .post)
        
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        self.messageFriendListService.fetch(params: userinfo.params, method: .post, url: getFriendListURL) { (response, error) in
            if let mappedResponse = response
            {
                self.contacts = mappedResponse
                self.massagingTableView.refreshControl?.endRefreshing()

            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
            }
        }
    }
    
}

extension MessagingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassegeListViewCell", for: indexPath) as? MassegeListViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(user: contacts[indexPath.row])
        return cell
    }
}

extension MessagingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
