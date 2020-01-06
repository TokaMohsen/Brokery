//
//  AddAssetAggregatedService.swift
//  Brokery
//
//  Created by ToqaMohsen on 1/6/20.
//  Copyright © 2020 Toqa. All rights reserved.
//

import Foundation
import UIKit

class AddAssetAggregatedService {
    
    private var uploadAssetFilesService: UploadAssetFilesService?
    private var createAssetPostService: CreateAssetPostService?
    

    // MARK: - API Methods
    
    func fetchRequest(assetImages : [UIImage]? , assetId : String? , createAssetParams : JSON? , completionBlock: @escaping (StatusObject?, WebError<CustomError>?) -> ()) {
        
        uploadAssetFilesService = UploadAssetFilesService()
        createAssetPostService = CreateAssetPostService()
        
        
        var uploadAssetFilesStatus = false
        var createAssetStatus = false
        
        
        var aggregatedError: WebError<CustomError>?
        
        let group = DispatchGroup()
        if let assetImagesSet = assetImages , let assetId = assetId
        {
            group.enter()
            uploadAssetFilesService?.post(images: assetImagesSet , assetId: assetId , completion: { (statusObject, error) in
                if error == nil {
                    uploadAssetFilesStatus = statusObject?.data ?? false
                }
                else {
                    aggregatedError = error
                }
                
                group.leave()
            })
            
            
        }
        
        group.enter()
        
        var userinfo = Resource<AssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: createAssetURL, method: .post)
        if let params = createAssetParams{
            userinfo.params = params
        }
        
        self.createAssetPostService?.post(params: userinfo.params, method: .post, url: createAssetURL) { (response, error) in
            if error == nil
            {
                createAssetStatus = response?.success ?? false
            }
            else
            {
                aggregatedError = error

            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            let result = StatusObject(success: uploadAssetFilesStatus && createAssetStatus, data: uploadAssetFilesStatus && createAssetStatus, count: nil, code: nil)
            completionBlock(result, aggregatedError)
        }
    }
}
