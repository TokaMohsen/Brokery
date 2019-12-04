//
//  AddAssetViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AddAssetViewController: BaseViewController {

    @IBOutlet var assetAddressTextField: UITextField!
    @IBOutlet var assetNameTextField: UITextField!
    @IBOutlet var assetDescriptionTextField: UITextField!
    @IBOutlet var hashtagTextField: UITextField!
    @IBOutlet var assetTypeDropdownTextField: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
//        //// The list of array to display. Can be changed dynamically
//        dropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
//        //Its Id Values and its optional
//        dropDown.optionIds = [1,23,54,22]
//
//        // Image Array its optional
//        dropDown.ImageArray = [👩🏻‍🦳,🙊,🥞]
//        // The the Closure returns Selected Index and String
//        dropDown.didSelect{(selectedText , index ,id) in
//            self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
//        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hashtagBtnAction(_ sender: UIButton) {
    }
    @IBAction func setLocationBtnAction(_ sender: UIButton) {
    }
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func statusSegmantedControlAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
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
