//
//  AddAssetViewController.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire

class AddAssetViewController: BaseViewController, UIPickerViewDelegate ,UINavigationControllerDelegate {

    @IBOutlet var assetAddressTextField: UITextField!
    @IBOutlet var assetNameTextField: UITextField!
    @IBOutlet var assetDescriptionTextField: UITextField!
    @IBOutlet var hashtagTextField: UITextField!
    @IBOutlet var assetTypeDropdownTextField: DropDown!
    
    var imageController : UIImagePickerController?
    var tempPickedImg : UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageController = UIImagePickerController()
        imageController?.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        
//        //// The list of array to display. Can be changed dynamically , testing
//        //Its Id Values and its optional
//        dropDown.optionIds = [1,23,54,22]
//
//        // Image Array its optional
//        dropDown.ImageArray = [👩🏻‍🦳,🙊,🥞]
//
//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func hashtagBtnAction(_ sender: UIButton) {
    }
    @IBAction func setLocationBtnAction(_ sender: UIButton) {
    }
    
    @IBAction func addPhotoBtnAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose", message: "Gallery or take photo", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
 
        
        let Phototake = UIAlertAction(title: "Take your photo", style: .default) { (action) in

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
          
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        }
    }
    
    @IBAction func statusSegmantedControlAction(_ sender: UISegmentedControl) {
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
    }
    private func setupAssetTypeMenu( assetTypes : [String])
    {
        //        //// The list of array to display. Can be changed dynamically , testing
        //        //Its Id Values and its optional
        //        dropDown.optionIds = [1,23,54,22]
        
        assetTypeDropdownTextField.optionArray = ["Option 1", "Option 2", "Option 3"]
        
           // The the Closure returns Selected Index and String
//        dropDown.didSelect{(selectedText , index ,id) in
//            //            self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
//            //        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
            // imageViewPic.contentMode = .scaleToFill
    
            //imageViewPic.image = pickedImage
        tempPickedImg = pickedImage
    
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupImagesCollection()
    {
        
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
