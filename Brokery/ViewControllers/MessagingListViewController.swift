//
//  MessagingListViewController.swift
//  Brokery
//
//  Created by Sawy on 2/11/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import UIKit

class MessagingListViewController: BaseViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var massagingTableView: UITableView!
    
    @IBOutlet var noDataView: UIView!
    
    @IBOutlet var noDataLbl: UILabel!
    var contacts = [UserDtoMessageObject]()
    private lazy var messageFriendListService = GetMessageFriendListService()

    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getContactListTask: URLSessionDataTask!
    var pageNunmber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLbl.text = emptyContactsMessagerTableMsg
        massagingTableView.dataSource = self
        massagingTableView.delegate = self
        massagingTableView.register(UINib(nibName: "MassegeListViewCell", bundle: nil), forCellReuseIdentifier: "MassegeListViewCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 251/255, green: 190/255, blue: 32/255, alpha: 1)
        refreshControl.addTarget(self, action: #selector(getMeassagingList), for: UIControl.Event.valueChanged)
        massagingTableView.refreshControl = refreshControl
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search..."
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Messenger")
        noDataView.isHidden = true
        getMeassagingList(withSearchText: nil)
        pageNunmber = 0
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count != 0 else { return }
        getMeassagingList(withSearchText: text)
    }
    
    @objc func getMeassagingList(withSearchText search: String?) {
        var userinfo = Resource< MessageFriendListObject , CustomError>(jsonDecoder: JSONDecoder(), path: getFriendListURL, method: .post)
        
        userinfo.params = ["Page": pageNunmber,
                           "PageSize": "10"]
        
        if let search = search {
            let filter = ["key": "Title", "value": search]
            userinfo.params["Filter"] = filter
        }
        
        self.messageFriendListService.fetch(params: userinfo.params, method: .post, url: getFriendListURL) { (response, error) in
            if let mappedResponse = response?.data
            {
                self.contacts = mappedResponse
                 DispatchQueue.main.async {
                    if (self.contacts.count > 0)
                    {
                        self.massagingTableView.reloadData()
                    }
                    else
                    {
                        self.noDataView.isHidden = false
                    }
                   self.massagingTableView.refreshControl?.endRefreshing()
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
        getMeassagingList(withSearchText: nil)
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 40.0 {
            loadMore()
        }
    }
}

extension MessagingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoStoryboard = UIStoryboard(name: "Messaging", bundle: nil)
             if let messageDetailsVC = infoStoryboard.instantiateViewController(withIdentifier: "MessagingDetailsViewController") as? MessagingDetailsViewController {
                 messageDetailsVC.contact = self.contacts[indexPath.row]
                 self.navigationController?.pushViewController(messageDetailsVC, animated: true)
             }
    }
}
