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
    
    var contacts = [ContactDto]()
    var currentContact : ContactDto?

    private lazy var allContactListService = GetAllContactListService()
    private lazy var followUserService = FollowUserService()
    private lazy var unfollowUserService = UnfollowUserService()

    var updateFollowBtnProtocolDelegate : UpdateRebsListTableCellProtocol?

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getContactListTask: URLSessionDataTask!
   // var tableCustomCell : RebsListTableCustomCell? = UIView() as? RebsListTableCustomCell

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Contact List")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.register(UINib(nibName: "RebsListTableCustomCell", bundle: nil), forCellReuseIdentifier: "ContactCard")
        contactsTableView.dataSource = self
        contactsTableView.delegate = self
        

        self.activityIndicator.startAnimating()
        fetchUserContacts()
        // Do any additional setup after loading the view.
    }
    
    func fetchUserContacts()
    {//getListOfALLContactsURL
        var userinfo = Resource< GetContactsObject , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfALLContactsURL, method: .get)
        
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
        //"DestinationID" : "1dd71bb1-a1bb-4aba-814f-e58b794285bc"]
        self.allContactListService.fetch(params: userinfo.params, method: .get, url: getListOfALLContactsURL) { (response, error) in
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
        cell.setup(contacts[indexPath.row])
        cell.rebsListTableCellDelegate = self
        currentContact = contacts[indexPath.row]
        return cell
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
                }
                self.updateFollowBtnProtocolDelegate?.updateFollowBtn(title: "UnFollow")
            }
            else if error != nil {
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error", title: "Server Error")
                }
                self.updateFollowBtnProtocolDelegate?.updateFollowBtn(title: "Follow")

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
                self.updateFollowBtnProtocolDelegate?.updateFollowBtn(title: "Follow")

             }
             else if error != nil {
                 DispatchQueue.main.async {
                     self.showErrorAlert(with: "error", title: "Server Error")
                 }
                self.updateFollowBtnProtocolDelegate?.updateFollowBtn(title: "UnFollow")

             }
         }
     }
}
