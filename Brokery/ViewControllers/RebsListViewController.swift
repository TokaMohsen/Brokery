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
    private lazy var allContactListService = GetAllContactListService()
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    
    var getContactListTask: URLSessionDataTask!
    
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
    {
        var userinfo = Resource< ContactList , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfALLContactsURL, method: .get)
        
        userinfo.params = ["Page": "0",
                           "PageSize": "10"]
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RebsListViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contactsTableView.dequeueReusableCell(withIdentifier: "ContactCard", for: indexPath) as? RebsListTableCustomCell else {
            return UITableViewCell()
        }
        //        if let contacts = contacts
        //        {
        cell.setup(contacts[indexPath.row])
        //  }
        
        return cell
    }
}
