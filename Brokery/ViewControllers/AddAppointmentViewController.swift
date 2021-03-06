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
    
    
    var appointment = AppointmentDto()
    var dropListProtocolDelegate : DropDownListsProtocol?
    
    var asset : AssetDto?
    var assetId : String?
    var developerId : String?
    var contacts : [Contact]?
    var contactId : String?
    var AppointmentStatus : Int = 0
    var dateTime : String?
    static let sharedWebClient = WebClient.init(baseUrl: BaseAPIURL)
    var customView : DropDownListsSelectionCustomView? = UIView() as? DropDownListsSelectionCustomView
    
    var appointmentTask : URLSessionDataTask!
    
    @IBAction func chooseContactBtnAction(_ sender: UIButton) {
        setupChooseContactList(contacts: self.contacts)
        chooseContactsDropList.showList()
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
        createAppointment()
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        showAlert(with: "Are you sure u want to discard changes? ", title: "Alert")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //customView.dropListProtocolDelegate = self
        
        if let assetModel = self.asset
        {
            let assetCard = SimpleAssetBasedCard(frame: appointmentSourceUIView.frame)
            assetCard.setup(assetModel)
            self.assetId = assetModel.id
            self.developerId = assetModel.ownerId
            assetCard.frame = appointmentSourceUIView.bounds
            assetCard.bounds.size = appointmentSourceUIView.bounds.size
            
            assetCard.center = appointmentSourceUIView.center
            appointmentSourceUIView.addSubview(assetCard)
            appointmentSourceUIView.translatesAutoresizingMaskIntoConstraints = false
        }
        else{
            customView = DropDownListsSelectionCustomView(frame: appointmentSourceUIView.frame)
            fetchUserListData { (data, error) in
                if let data = data {
                    self.customView?.devolopers = data
                    DispatchQueue.main.async {
                        self.customView?.registerNibView()
                    }
                    
                }
            }
            
            // customView?.fetchDevelopers()
            customView?.frame = appointmentSourceUIView.bounds
            customView?.bounds.size = appointmentSourceUIView.bounds.size
            
            customView?.appointmentDelegate = self
            customView?.dropDownListsSetupDelegate = self
            
            customView?.center = appointmentSourceUIView.center
            appointmentSourceUIView.addSubview(customView ?? UIView())
            appointmentSourceUIView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var timeFormatter = DateFormatter()
        timeFormatter.dateFormat = dateTimeFormat
        let selectedDateTime = timeFormatter.string(from:  datePicker.date);
        self.dateTime = selectedDateTime
        
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
        
        self.dateTime = timeFormatter.string(from: datePicker.date)
    }
    
    func fetchUserListData(completion : @escaping ([UserDto]?, WebError<CustomError>?) -> ())
    {
        var userNames = [UserDto]()
        appointmentTask?.cancel()
        
        // activityIndicator.startAnimating()
        
        let userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUsersListURL, method: .get)
        
        self.usersListService.fetch(params: userinfo.params, method: .get, url: getUsersListURL) { (response, error) in
            if let mappedResponse = response?.data
            {
                userNames = mappedResponse
                self.customView?.devolopers = userNames
                self.dropListProtocolDelegate?.getUserListData(userList: userNames)
                completion(userNames , nil)
                
            } else if error != nil {
                //controller.handleError(error)
                completion(nil , error)
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error")
                }
            }
        }
        //  self.activityIndicator.stopAnimating()
        // }
        //return userNames
    }
    
    func fetchUserAssets(user_id : String , completion : @escaping ([SimpleAssetDto]?, WebError<CustomError>?) -> ())
    {
        var asset = [SimpleAssetDto]()
        
        var userinfo = Resource<SimpleAssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: getUserAssetsURL, method: .get)
        
        // DispatchQueue.main.async {
        userinfo.params["UserID"] = user_id
        self.userAssetsService.fetch(params: userinfo.params, method: .get, url: getUserAssetsURL) { (response, error) in
            if let mappedResponse = response
            {
                // self.activityIndicator.stopAnimating()
                asset = mappedResponse
                completion(asset , nil)
            }
            else if error != nil {
                self.dropListProtocolDelegate?.getUserAssetsData(assets: asset)
                DispatchQueue.main.async {
                    self.showErrorAlert(with: "error")
                }
                completion(nil , error)
            }
        }
        
        
        // }
    }
    
    func fetchUserContacts()
    {
        var userinfo = Resource< ContactList , CustomError>(jsonDecoder: JSONDecoder(), path: getListOfContactsURL, method: .get)
        
        self.listOfUserContactsService.fetch(params: userinfo.params, method: .get, url: getListOfContactsURL) { (response, error) in
            if let mappedResponse = response
            {
                //self.activityIndicator.stopAnimating()
                self.contacts = mappedResponse
            }
            else if error != nil {
                DispatchQueue.main.async {

                self.showErrorAlert(with: "error")
                }
            }
        }
        
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
    
    func createAppointment()
    {
        self.appointmentTask?.cancel()
        //        DispatchQueue.main.async {
        //            self.activityIndicator.startAnimating()
        //        }
        var userinfo = Resource<Object , CustomError>(jsonDecoder: JSONDecoder(), path: createAppointmentURL, method: .post)
        
        if let contactId = self.contactId
        {
            userinfo.params["contactId"] = contactId
        }
        if let assetId =  self.assetId
        {
            userinfo.params["assetId"] = assetId
        }
        if let description = self.appointmentDescriptionText.text
        {
            userinfo.params["description"] = description
        }
        if let developerId = self.developerId
        {
            userinfo.params["developerId"] = developerId
        }
        if let dateTime = self.dateTime
        {
            userinfo.params["dateTime"] = dateTime
        }
        userinfo.params["status"] = self.AppointmentStatus
        if let brokerId = LocalStore.getUserId()
        {
            userinfo.params["brokerId"] = brokerId
        }
        
        self.createAppointmentService.preformRequest(params: userinfo.params, method: .post, url: createAppointmentURL) { (response, error) in
            if let mappedResponse = response
            {
                self.navigateToList()
            }
                
            else if error != nil {
                DispatchQueue.main.async {

                self.showErrorAlert(with: "Server error")
                }
                //controller.handleError(error)
            }
        }
        
    }
    
    private func navigateToList()
    {
        DispatchQueue.main.async {
            
            let appointmentsStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
            if let viewController = appointmentsStoryboard.instantiateViewController(withIdentifier: "AppointmentsListViewController") as? AppointmentsListViewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(with message: String , title : String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,  handler: { (action) in
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        })
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancleAction)
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

extension AddAppointmentViewController : DropDownListsSetupProtocol
{
    func getDeveloperId(id: String) {
        self.developerId = id
        fetchUserAssets(user_id: id, completion: { (assetsList, error) in
            if let assetsList = assetsList{
                self.dropListProtocolDelegate?.getUserAssetsData(assets: assetsList)
            }
            else{
                self.dropListProtocolDelegate?.getUserAssetsData(assets: nil)

            }
        })
        
    }
    
    func getAssetId(id: String) {
        self.assetId = id
    }
    
    
}
