//
//  RebsListViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 2/7/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class RebsListViewController: BaseViewController {
    @IBOutlet var contactsTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var contacts = [UserDto]()
    var currentContact : UserDto?
    var pageNunmber = 0
    var followBtnTitleFlag = true
    private lazy var allContactListService = GetAllContactListService()
    private lazy var followUserService = FollowUserService()
    private lazy var unfollowUserService = UnfollowUserService()
    
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getContactListTask: URLSessionDataTask!
    // var tableCustomCell : RebsListTableCustomCell? = UIView() as? RebsListTableCustomCell
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageNunmber = 0
        setupNavigationBar(title: "Contact List")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.register(UINib(nibName: "RebsListTableCustomCell", bundle: nil), forCellReuseIdentifier: "ContactCard")
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        
        self.activityIndicator.startAnimating()
        fetchUserContacts(withSearchText: nil)
        // Do any additional setup after loading the view.
    }
    
    func fetchUserContacts(withSearchText search: String?)
    {
        var userinfo = Resource< GetContactsObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUsersListURL, method: .get)
        
        userinfo.params = ["Page": pageNunmber,
                           "PageSize": "10"]
        if let search = search {
            let filter = ["key": "Title", "value": search]
            userinfo.params["Filter"] = filter
        }
        self.allContactListService.fetch(params: userinfo.params, method: .get, url: getUsersListURL) { (response, error) in
            if let mappedResponse = response
            {
                self.contacts = mappedResponse
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.contactsTableView.reloadData()
                }
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
        self.fetchUserContacts(withSearchText: nil)
    }
}

extension RebsListViewController : UITableViewDelegate , UITableViewDataSource , RebsListTableCellDelegateProtocol
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: "ContactCard", for: indexPath) as? RebsListTableCustomCell else {
            return UITableViewCell()
        }
        cell.setup(contacts[indexPath.row] , followBtnEnabled: followBtnTitleFlag)
        currentContact = contacts[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 40.0 {
            loadMore()
        }
    }
    
    func followContact() {
        var userinfo = Resource< GetContactsObject , CustomError>(jsonDecoder: JSONDecoder(), path: followUserURL, method: .get)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        if let userID  = currentContact?.id {
            userinfo.params = ["ID": userID]
        }
        self.followUserService.fetch(params: userinfo.params, method: .post, url: followUserURL) { (response, error) in
            if  response == true
            {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    //to set btn title to "unFollow"
                    self.followBtnTitleFlag = false
                   // self.updateFollowBtnProtocolDelegate?.updateFollowBtn(title: "UnFollow")

                }
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
            }
        }
    }
    
    func unfollowContact() {
        var userinfo = Resource< GetContactsObject , CustomError>(jsonDecoder: JSONDecoder(), path: followUserURL, method: .get)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        if let userID  = currentContact?.id {
            userinfo.params = ["ID": userID]
        }
        self.unfollowUserService.fetch(params: userinfo.params, method: .post, url: followUserURL) { (response, error) in
            if  response == true
            {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                //to set btn title to "Follow" again
                self.followBtnTitleFlag = true
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
                
            }
        }
    }
}
