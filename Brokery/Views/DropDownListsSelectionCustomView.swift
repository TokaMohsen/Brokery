//
//  DropDownListsSelectionCustomView.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/24/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import iOSDropDown

class DropDownListsSelectionCustomView: UIView , UITextFieldDelegate , DropDownListsProtocol {
    
    
    @IBOutlet var chooseDeveloperMenu: DropDown!
    
    @IBOutlet var chooseAssetMenu: DropDown!
    
    var assetsList = [SimpleAssetDto]()
    var assetId : String?
    var devoloperId : String?
    var devolopers = [UserDto]()
    var appointmentDelegate : AppointmentDelegateProtocol?
    var dropDownListsSetupDelegate : DropDownListsSetupProtocol?
    
    var customView = UIView()
    // var chooseDeveloperDropDown = DropDown()
    var addAppointmetVC : AddAppointmentViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibView()
        addAppointmetVC?.dropListProtocolDelegate = self
        
        setupDevoloperMenu()
        fetchAssets()
        setupAssetMenu()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chooseDeveloperMenu.showList()
        
    }
    
    
    func fetchDevelopers()
    {
        appointmentDelegate?.fetchUserListData(completion: { (data, error) in
            if let data = data
            {
                self.devolopers = data
                self.setupDevoloperMenu()
            }
        })
    }
    
    func fetchAssets()
    {
          if let selectedItem = self.devoloperId
            {
                appointmentDelegate?.fetchUserAssets(user_id: selectedItem, completion: { (assetsList, error) in
                    if let assetsList = assetsList{
                        self.assetsList = assetsList
                        self.setupAssetMenu()
                    }
                })
                
            }
        
    }
    
    func setupDevoloperMenu()
    {
        if self.devolopers.count > 0 {
            chooseDeveloperMenu.optionArray = self.devolopers.compactMap({$0.name})
            chooseDeveloperMenu.selectedRowColor = .lightGray
            chooseDeveloperMenu.didSelect { (selectedItem, index, id) in
                self.chooseDeveloperMenu.text = selectedItem
                self.devoloperId  = self.devolopers[index].id
                self.dropDownListsSetupDelegate?.getDeveloperId(id: self.devoloperId ?? "")
                self.fetchAssets()
            }
        }
        else
        {
            chooseDeveloperMenu.optionArray = ["no data"]
            chooseDeveloperMenu.didSelect { (selectedItem, index, id) in
                self.chooseDeveloperMenu.text = selectedItem
            }
        }
        
    }
    
    func setupAssetMenu()
    {
        if self.assetsList.count > 0 {
            chooseAssetMenu.optionArray = self.assetsList.compactMap({$0.name})
            // self.view.bringSubviewToFront(yourView)
            chooseDeveloperMenu.selectedRowColor = .lightGray

            chooseAssetMenu.didSelect { (selectedItem, index, id) in
                self.chooseAssetMenu.text = selectedItem
                self.assetId  = self.assetsList[index].id
                self.dropDownListsSetupDelegate?.getAssetId(id: self.assetId ?? "")
            }
        }
        else
        {
            chooseAssetMenu.optionArray = ["no data"]
            chooseAssetMenu.didSelect { (selectedItem, index, id) in
                self.chooseAssetMenu.text = selectedItem
            }
            
        }
    }
    
    func registerNibView() {
        let nib = UINib.init(nibName: String(describing: type(of: self)), bundle: nil)
        let views = nib.instantiate(withOwner: self, options: nil)
        if let view = views[0] as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
            self.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addAppointmetVC?.dropListProtocolDelegate = self
        
        setupDevoloperMenu()
    }
    
    
    func getUserListData(userList: [UserDto]?) {
        if let users = userList {
            self.devolopers = users
            setupDevoloperMenu()
        }
        
    }
    
    func getUserAssetsData(assets: [SimpleAssetDto]?) {
        if let assets = assets {
            self.assetsList = assets
            setupAssetMenu()
        }
    }
    
}
