//
//  AddFavoriteAssetPostService.swift
//  Brokery
//
//  Created by ToqaMohsen on 12/31/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation
///api/Asset/AddFavoriteAsset

class AddFavoriteAssetPostService {
    func fetch(params : JSON , method : RequestMethod , url : String , completion: @escaping (FavoriteAssetDto?, WebError<CustomError>?) -> ())
    {
        let postFavouriteAssetTask: URLSessionDataTask!
        
        var userinfo = Resource<FavoriteAssetObject , CustomError>(jsonDecoder: JSONDecoder(), path: url, method: .post)
        userinfo.params = params
        
        postFavouriteAssetTask = AssetDetailsViewController.sharedWebClient.load(resource: userinfo, urlMethod: method) {[weak self] response in
            if let mappedResponse = response.value?.data
            {
                completion(mappedResponse , nil)
            } else if let error = response.error {
                //controller.handleError(error)
                completion(nil , response.error)
            }
            
        }
    }
}
