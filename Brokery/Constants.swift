//
//  Constants.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/14/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import Foundation

let serviceFailureMsg = "service failed"
let filterFailureMsg = "Keyword doesn't match any hashtag"
let missingRequiredMsg = "This field is required"
let regexErrorMsg = "This field format is not correct"
let tokenPrefix = "bearer"
let BaseAPIURL = "https://rebsapp.com"
let AuthentactionURL = "/api/Account/Authenticate"
let RegisterAccountURL = "/api/User/Register"
let loginWithFacebookURL = "/api/Account/LoginByFaceBook"
let LoginWithGoogleURL = "/api/Account/RegisterAccount"
let getUserInfoByTokenURL = "/api/User/GetByToken"
let AccountGetAllURL = "/api/Account/GetAll"
let AccountsListURL = "/api/Account/GetAccountsList"
let AllAssestsURL = "/api/Asset/GetAll"
let AssetCreateURL = "/api/Asset/Create"
let FollowedAssetsURL = "/api/Asset/GetFollowedDeveloperAssets"
let HashtagGetURL = "/api/HashTag/Get"

//Regex
let MobilePhoneNumberRegex = "^[0-9]{10,18}$";
let EmailAddressRegex = "^^([A-Za-z0-9]){1}[A-Z0-9a-z._%+-]+@([A-Za-z0-9]){1}[a-zA-Z_0-9-]+?([A-Za-z0-9]){1}(\\.[a-zA-Z]{2,})+$";
