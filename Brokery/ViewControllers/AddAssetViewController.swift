//
//  AddAssetViewController.swift
//  Brokery
//
//  Created by ToqaDev on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit

class AddAssetViewController: UIViewController {

    @IBOutlet var assetAddressTextField: UITextField!
    @IBOutlet var assetNameTextField: UITextField!
    @IBOutlet var assetDescriptionTextField: UITextField!
    @IBOutlet var hashtagTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
