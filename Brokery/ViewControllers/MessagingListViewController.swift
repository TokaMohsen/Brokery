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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        getMeassagingList(withSearchText: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count != 0 else { return }
        getMeassagingList(withSearchText: text)
    }
    
    @objc func getMeassagingList(withSearchText search: String?) {
//        massagingTableView.refreshControl?.endRefreshing()
    }
}

extension MessagingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassegeListViewCell", for: indexPath) as? MassegeListViewCell else {
            return UITableViewCell()
        }
        
        cell.setup()
        return cell
    }
}

extension MessagingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
