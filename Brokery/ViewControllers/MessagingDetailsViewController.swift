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
    
    @IBOutlet var noDataLbl: UILabel!
    @IBOutlet var noDataView: UIView!
    private lazy var createChatMessageService = CreateChatMessageService()
    private lazy var messageHistoryServices = GetMessageHistoryServices()
    var contact = UserDtoMessageObject()
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var createMsgTask: URLSessionDataTask!
    var msgs = [msgDto]()
    var toContact = UserDto()
    var pageNunmber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        noDataLbl.text = emptyMessagesTable
        messagesTableView.register(UINib(nibName: "MassegeDetailsViewCell", bundle: nil), forCellReuseIdentifier: "MassegeDetailsViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getMeassages), for: UIControl.Event.valueChanged)
        messagesTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Messenger")
        pageNunmber = 0
        noDataView.isHidden = true
        getMeassages()
    }
    
    @objc func getMeassages() {
        var userinfo = Resource< [MessageHistoryObject] , CustomError>(jsonDecoder: JSONDecoder(), path: getMessageHistoryURL, method: .get)
        
        userinfo.params = ["Page": pageNunmber,
                           "PageSize": "10"]
        if let contactId = self.contact.id
        {
            userinfo.params["DestinationID"] = contactId
        }
        self.messageHistoryServices.fetch(params: userinfo.params, method: .get, url: getMessageHistoryURL) { (response, error) in
            if let mappedResponse = response
            {
                self.msgs = mappedResponse
                DispatchQueue.main.async {
                    if (self.msgs.count > 0)
                    {
                        self.messagesTableView.reloadData()
                        
                    }
                    else
                    {
                        self.noDataView.isHidden = false
                    }
                    self.messagesTableView.refreshControl?.endRefreshing()
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
        if let toUser_id = self.contact.id
        {
            userinfo.params["toUserId"] = toUser_id
        }
        self.createChatMessageService.fetch(params: userinfo.params, method: .post, url: createMessagURL) { (response, error) in
            if let mappedResponse = response
            {
                self.getMeassages()
                self.messageTextView.text = ""
                
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
            }
        }
    }
    
    func loadMore() {
        pageNunmber += 1
        self.getMeassages()
    }
    
}

extension MessagingDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassegeDetailsViewCell", for: indexPath) as? MassegeDetailsViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(message: self.msgs[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 40.0 {
            loadMore()
        }
    }
}
