//
//  AppDelegate.swift
//  Brokery
//
//  Created by ToqaMohsen on 11/7/19.
//  Copyright © 2019 Toqa. All rights reserved.
//

import UIKit
import UICKeyChainStore
import GoogleSignIn
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       let keychainStore = UICKeyChainStore.init()
        keychainStore.accessibility = .always
        FirebaseApp.configure()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "949854548604-5geood4nlc35m64fok5hr711k0plat7p.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        
        //google maps AIzaSyB4ZQQHSyPdVdY3q4rK5SZ1zlXdeAT9S1w
        GMSServices.provideAPIKey("AIzaSyB4ZQQHSyPdVdY3q4rK5SZ1zlXdeAT9S1w")
        GMSPlacesClient.provideAPIKey("AIzaSyB4ZQQHSyPdVdY3q4rK5SZ1zlXdeAT9S1w")
        
        var initialViewController: UIViewController?
//        //just for testing
//        LocalStore.storeUserToken(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjBhZjMxOTM3LTQ2MTItNDE0NC05NjgwLTRjOWYyNmY4ODJmZCIsIm5hbWVpZCI6IjBhZjMxOTM3LTQ2MTItNDE0NC05NjgwLTRjOWYyNmY4ODJmZCIsIklzU3VwZXJBZG1pbiI6IlRydWUiLCJuYmYiOjE1NzU3MTQwOTksImV4cCI6MTU3NjMxODg5OSwiaWF0IjoxNTc1NzE0MDk5fQ.q5WR4AhEn9bT3nLdFMaKtbDY7Zn3AFbelJvJxxlP0RA")
        
        if let username = LocalStore.getUserToken() {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Assets", bundle: nil)
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "AssetMapViewController")
        } else {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        
        return true
    }
    
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


}

