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
    
    var assetsTitles = [String]()
    var devolopers = [String]()
    var appointmentDelegate : AppointmentDelegateProtocol?
    var customView = UIView()

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
            if let assetsList = appointmentDelegate?.fetchUserAssets(user_name: selectedItem)
            {
                self.assetsTitles = assetsList
                setupAssetMenu()
            }
        }
    }
    
    func setupDevoloperMenu()
    {
        chooseDeveloperDropDown.optionArray = self.devolopers
        chooseDeveloperDropDown.didSelect { (selectedItem, index, id) in
            self.chooseDeveloperDropDown.text = selectedItem
            
            self.fetchAssets()
        }
    }
    
    func setupAssetMenu()
     {
         chooseAssetMenu.optionArray = self.assetsTitles
        // self.view.bringSubviewToFront(yourView)

         chooseAssetMenu.didSelect { (selectedItem, index, id) in
             self.chooseAssetMenu.text = selectedItem
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
