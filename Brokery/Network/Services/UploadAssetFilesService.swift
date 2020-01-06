//
//  UploadAssetFilesService.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/5/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
import Alamofire

class UploadAssetFilesService
{
    func post(images : [UIImage] , assetId : String, completion: @escaping (StatusObject?, WebError<CustomError>?) -> ()){
        var imgsData = [Data]()
        
        for image in images {
            //let image = UIImage.init(named: "myImage")
            let imgData = image.jpegData(compressionQuality: 0.2)!
            imgsData.append(imgData)
        }
        let parameters = ["isBackgroundPhoto": "false",
                          "ID" : assetId
                         ]
        //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for image in imgsData {
                multipartFormData.append(image, withName: "fileset\(Date().timeIntervalSince1970)",fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                if let value = value.data(using: String.Encoding.utf8){
                    multipartFormData.append(value, withName: key)
                }
            }
            //Optional for extra parameters
        },
                         to:BaseAPIURL + assetUploadFilesURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    completion(response.result.value as? StatusObject , nil)
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(nil , encodingError as? WebError<CustomError>)
            }
        }
        
    }
}
