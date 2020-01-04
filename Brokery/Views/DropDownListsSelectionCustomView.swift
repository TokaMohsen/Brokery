//
//  DropDownListsSelectionCustomView.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/24/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
import iOSDropDown

class DropDownListsSelectionCustomView: UIView , UITextFieldDelegate {
    
    @IBOutlet var chooseDeveloperMenu: DropDown!
    
    @IBOutlet var chooseAssetMenu: DropDown!
    
    var assetsList = [AssetDto]()
    var assetId : String?
    var devoloperId : String?
    var devolopers = [UserDto]()
    var appointmentDelegate : AppointmentDelegateProtocol?
    var customView = UIView()
    var dropListProtocolDelegate : DropDownListsProtocol?
    var chooseDeveloperDropDown = DropDown()


    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibView()
        fetchDevelopers()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        chooseDeveloperDropDown.showList()
       
    }

    func fetchDevelopers()
    {
        if let userList = appointmentDelegate?.fetchUserListData()
        {
            self.devolopers = userList
            setupDevoloperMenu()
        }
    }
    
    func fetchAssets()
    {
        if let selectedItem = chooseDeveloperDropDown.text
        {
            if let assetsList = appointmentDelegate?.fetchUserAssets(user_id: selectedItem)
            {
                self.assetsList = assetsList
                setupAssetMenu()
            }
        }
    }
    
    func setupDevoloperMenu()
    {
        chooseDeveloperDropDown.optionArray = self.devolopers.compactMap({$0.name})
        chooseDeveloperDropDown.didSelect { (selectedItem, index, id) in
            self.chooseDeveloperDropDown.text = selectedItem
            self.devoloperId  = self.assetsList[index].id
             self.dropListProtocolDelegate?.getDeveloperId(id: self.devoloperId ?? "")
            self.fetchAssets()
        }
    }
    
    func setupAssetMenu()
     {
        chooseAssetMenu.optionArray = self.assetsList.compactMap({$0.title})
        // self.view.bringSubviewToFront(yourView)

         chooseAssetMenu.didSelect { (selectedItem, index, id) in
             self.chooseAssetMenu.text = selectedItem
             self.assetId  = self.assetsList[index].id
            self.dropListProtocolDelegate?.getAssetId(id: self.assetId ?? "")
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
        
    }
}
