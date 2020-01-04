//
//  AddAppointmentViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/16/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import iOSDropDown

class AddAppointmentViewController: BaseViewController , AppointmentDelegateProtocol {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var appointmentDescriptionText: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var appointmentSourceUIView: UIView!
    
    @IBOutlet var chooseContactsDropList: DropDown!
    private lazy var usersListService = GetUsersListService()
    private lazy var userAssetsService = GetUserAssetsService()
    private lazy var createAppointmentService = CreateAppointmentService()
    private lazy var listOfUserContactsService = GetListOfUserContactsService()
    
    let assetCard = SimpleAssetBasedCard()
    let dropLists = DropDownListsSelectionCustomView()
    
    var appointment = AppointmentDto()
    var asset : AssetDto?
    var assetId : String?
    var contacts : [Contact]?
    var contactId : String?
    
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    let customView = DropDownListsSelectionCustomView()
    
    var appointmentTask : URLSessionDataTask!
    
    @IBAction func chooseContactBtnAction(_ sender: UIButton) {
        setupChooseContactList(contacts: self.contacts)
        chooseContactsDropList.showList()
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropLists.appointmentDelegate = self
        dropLists.dropListProtocolDelegate = self
        if let assetModel = self.asset
        {
            assetCard.registerNibView()
            assetCard.setup(assetModel)
            assetCard.frame = appointmentSourceUIView.bounds
            assetCard.bounds.size = appointmentSourceUIView.bounds.size
            
            assetCard.center = appointmentSourceUIView.center
            appointmentSourceUIView.addSubview(assetCard)
            appointmentSourceUIView.translatesAutoresizingMaskIntoConstraints = false
        }
        else{
            customView.fetchDevelopers()
            customView.registerNibView()
            customView.frame = appointmentSourceUIView.bounds
            customView.bounds.size = appointmentSourceUIView.bounds.size
            
            customView.center = appointmentSourceUIView.center
            appointmentSourceUIView.addSubview(customView)
            appointmentSourceUIView.translatesAutoresizingMaskIntoConstraints = false
        }
        datePicker.addTarget(self, action: #selector(handlePicker(sender:)), for: UIControl.Event.valueChanged)
        
        fetchUserContacts()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(title: "Add Appointment")
    }
    
    func getAppointmentModel(appointment : AppointmentDto)
    {
        self.appointment = appointment
    }
    
    func getAssetModel(asset : AssetDto)
    {
        self.asset = asset
    }
    
    
    @objc func handlePicker(sender: UIDatePicker) {
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dateTimeFormat
        
        var strDate = timeFormatter.string(from: datePicker.date)
        // do what you want to do with the string.
    }
    
    func fetchUserListData() -> [String]?
    {
        var userNames = [String]()
        appointmentTask?.cancel()
        
        // activityIndicator.startAnimating()
        
        let userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUsersListURL, method: .post)
        
        self.usersListService.fetch(params: userinfo.params, method: .get, url: getUsersListURL) { (response, error) in
            if let mappedResponse = response?.data
            {
                // self.activityIndicator.stopAnimating()
                userNames = mappedResponse.compactMap({$0.name})
                // self.dropLists.fetchDevelopers(developerList: usersNames)
            } else if error != nil {
                //controller.handleError(error)
                self.showErrorAlert(with: "error")
            }
        }
        //  self.activityIndicator.stopAnimating()
        // }
        return userNames
    }
    
    func fetchUserAssets(user_id : String) -> [AssetDto]?
    {
        var asset = [AssetDto]()
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUserAssetsURL, method: .get)
        
        // DispatchQueue.main.async {
        userinfo.params["UserID"] = user_id
        self.userAssetsService.fetch(params: userinfo.params, method: .get, url: getUserAssetsURL) { (response, error) in
            if let mappedResponse = response
            {
                // self.activityIndicator.stopAnimating()
                asset = mappedResponse
            }
            else if error != nil {
                self.showErrorAlert(with: "error")
            }
        }
        return asset
        
        
        // }
        
    }
    
    func fetchUserContacts()
    {
        var contactsNames = [String]()
        
        var userinfo = Resource< ContactList , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfContactsURL, method: .get)
        
        self.listOfUserContactsService.fetch(params: userinfo.params, method: .get, url: getListOfContactsURL) { (response, error) in
            if let mappedResponse = response
            {
                //self.activityIndicator.stopAnimating()
                self.contacts = mappedResponse
            }
            else if error != nil {
                self.showErrorAlert(with: "error")
            }
        }
        
        
        // }
        
    }
    
    func setupChooseContactList(contacts : [Contact]?) {
        if let contacts = contacts
        {
            self.chooseContactsDropList.optionArray = contacts.count == 0 ? ["no data"] :  contacts.compactMap({$0.name})
            self.chooseContactsDropList.didSelect { (selectedItem, index, id) in
                self.chooseContactsDropList.text = selectedItem
                self.contactId = String(contacts[index].id ?? "")
            }
        }
        else
        {
            self.chooseContactsDropList.optionArray = ["no data"]
            self.chooseContactsDropList.didSelect { (selectedItem, index, id) in
                self.chooseContactsDropList.text = selectedItem
            }
        }
        self.chooseContactsDropList.selectedRowColor = .lightGray
        self.chooseContactsDropList.isSearchEnable = true
        
    }
    
    func createAppointment(developer : UserDto , asset : AssetDto )
    {
        self.appointmentTask?.cancel()
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: createAppointmentURL, method: .post)
        //        userinfo.params = ["developerId": currentUser.email! ,
        //                           "password": facebookPasswordConst,
        //                           "tokenSocialMedia": accessToken.tokenString
        //        ]
        if let contactId = self.contactId
        {
            userinfo.params["contactId"] = contactId
        }
        if let assetId =  self.assetId
        {
            userinfo.params["assetId"] = assetId
        }
        
        self.createAppointmentService.preformRequest(params: userinfo.params, method: .post, url: createAppointmentURL) { (response, error) in
            if let mappedResponse = response
            {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                let appointmentsStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
                if let appointmentVC = appointmentsStoryboard.instantiateViewController(withIdentifier: "AppointmentsListViewController") as? AppointmentsListViewController {
                    UIApplication.shared.keyWindow?.rootViewController = appointmentVC
                    self.dismiss(animated: true, completion: nil)
                }
                    
                else if error != nil {
                    //controller.handleError(error)
                }
            }
            
        }
    }
    
    //    func registerNibView() {
    //        let nib = UINib.init(nibName: String(describing: type(of: self)), bundle: nil)
    //        let views = nib.instantiate(withOwner: self, options: nil)
    //        if let view = views[0] as? UIView {
    //            view.frame = self.bounds
    //            self.addSubview(view)
    //            self.translatesAutoresizingMaskIntoConstraints = false
    //        }
    //
    //    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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

extension AddAppointmentViewController : DropDownListsProtocol
{
    func getAssetId(id: String) {
        self.assetId = id
    }
    
    
}
