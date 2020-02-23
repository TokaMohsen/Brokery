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
    
    private lazy var createChatMessageService = CreateChatMessageService()
    private lazy var messageHistoryServices = GetMessageHistoryServices()

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var createMsgTask: URLSessionDataTask!
    var msgs = [MessageDto]()
    var toContact = UserDto()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        messagesTableView.register(UINib(nibName: "MassegeDetailsViewCell", bundle: nil), forCellReuseIdentifier: "MassegeDetailsViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getMeassages), for: UIControl.Event.valueChanged)
        messagesTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Messenger")
        getMeassages()
    }
    
    @objc func getMeassages() {
        var userinfo = Resource< [MessageHistoryObject] , CustomError>(jsonDecoder: JSONDecoder(), path: getMessageHistoryURL, method: .get)
        
        userinfo.params = ["Page": "0",
                           "PageSize": "10",
                           "DestinationID" : "1dd71bb1-a1bb-4aba-814f-e58b794285bc"]
        self.messageHistoryServices.fetch(params: userinfo.params, method: .get, url: getMessageHistoryURL) { (response, error) in
            if let mappedResponse = response
            {
                self.msgs = mappedResponse
                DispatchQueue.main.async {
                    self.messagesTableView.refreshControl?.endRefreshing()
                    self.messagesTableView.reloadData()
                }
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        var userinfo = Resource< StatusObject , CustomError>(jsonDecoder: JSONDecoder(), path: createMessagURL, method: .post)
        var timeFormatter = DateFormatter()
           timeFormatter.dateFormat = dateTimeFormat
        
        let now = Date()
        timeFormatter.timeZone = TimeZone.current

        let selectedDateTime = timeFormatter.string(from: now)
        
        userinfo.params ["dateTime"] = selectedDateTime
        if messageTextView.text != ""
        {
            userinfo.params["body"] = messageTextView.text
        }
        if let user_id = LocalStore.getUserId()
        {
            userinfo.params["fromUserId"] = user_id
        }
        if let toUser_id = toContact.id
        {
            userinfo.params["toUserId"] = toUser_id
        }
        self.createChatMessageService.fetch(params: userinfo.params, method: .post, url: createMessagURL) { (response, error) in
            if let mappedResponse = response
            {
           
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
            }
        }
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
