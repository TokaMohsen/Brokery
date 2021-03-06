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
let emptyContactsMessagerTableMsg = "It seems that you have no contacts :("
let emptyMessagesTable = "No History , Say Hi"

//////backend params
let tokenPrefix = "bearer"
let facebookPasswordConst = "FaceBook"
let googlePasswordConst = "Google"

//let BaseAPIURL = "http://dev.rebsapp.com"
let BaseAPIURL = "https://rebsapp.com"
let AuthentactionURL = "/api/Account/Authenticate"
let RegisterAccountURL = "/api/User/Register"
let loginWithFacebookURL = "/api/Account/LoginByFaceBook"
let LoginWithGoogleURL = "/api/Account/RegisterAccount"
let forgotPasswordURL = "/api/Account/ForgotPassword"
let getUserInfoByTokenURL = "/api/User/GetByToken" // for menu
let AccountGetAllURL = "/api/Account/GetAll"
let AccountsListURL = "/api/Account/GetAccountsList"
//assets
let AllAssestsURL = "/api/Asset/GetAll"
let AssetCreateURL = "/api/Asset/Create"
let FollowedAssetsURL = "/api/Asset/GetFollowedDeveloperAssets"
let HashtagGetURL = "/api/HashTag/Get"
let GetAssetTypeListURL = "/api/AssetType/GetAssetTypeList"
let createAssetURL = "/api/Asset/Create"
let assetUploadFilesURL = "/api/Asset/UploadFiles"
let favouriteAssetURL = "/api/Asset/AddFavoriteAsset"
//appointment 
let getUserAssetsURL = "/api/Asset/GetUserAssets"
let getUsersListURL = "/api/User/GetUsersList"
let createAppointmentURL = "/api/Appointment/Create"
let getAllAppointmentsURL = "/api/Appointment/GetAll"
let getListOfContactsURL = "/api/Contact/GetContactList"
let getListOfAppointmentsURL = "/api/Appointment/GetInterval"
//contact list
let getListOfALLContactsURL = "/api/Contact/GetAll"
let followUserURL = "/api/User/Follow"
let unfollowUserURL = "/api/User/UnFollow"
//messanger
let getFriendListURL = "/api/User/GetFriendsList"
let getMessageHistoryURL = "api/Message/GetMessageHistory"
let createMessagURL = "/api/Message/Create"
//Regex
let MobilePhoneNumberRegex = "^[0-9]{10,18}$";
let EmailAddressRegex = "^^([A-Za-z0-9]){1}[A-Z0-9a-z._%+-]+@([A-Za-z0-9]){1}[a-zA-Z_0-9-]+?([A-Za-z0-9]){1}(\\.[a-zA-Z]{2,})+$";
//Format
let dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
let listDateTimeFormat = "yyyy-MM-dd"
