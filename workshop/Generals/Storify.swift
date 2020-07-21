//
//  Storify.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 UserDefaults Identifier.
 */
struct Preferences {
    static let isLoggedIn = "is_logged_in"
    static let tokenLogin = "token_login"
    static let tokenRefresh = "token_refresh"
    static let userData = "user_data"
}

/**
 Class used to handle stored Data using Repository pattern.
 */
class Storify: NSObject {
    static let shared = Storify()
    
    // Token
    var currentFcmToken: String!
    
    // Paging
    var page = [String: JSON]()
    
    
    // MARK: Authentications
    func handleSuccessfullLogin(_ data: JSON, _ meta: JSON) {
        setUserDefaultInformation(meta)
        Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": true])
    }
    
    func handleSuccessfullLogout(_ data: JSON) {
        logoutUser()
    }
    
    func handleRefreshToken(_ data: JSON) {
        setUserDefaultInformation(data)
    }
    
    private func setUserDefaultInformation(_ meta: JSON) {
        let token = meta["token"].stringValue
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.set(token, forKey: Preferences.tokenLogin)
    }
    
    func logoutUser() {
        let pref = UserDefaults.standard
        pref.set(false, forKey: Preferences.isLoggedIn)
        pref.removeObject(forKey: Preferences.tokenLogin)
        pref.removeObject(forKey: Preferences.userData)
        removeData()
    }
    
    private func removeData() {
        DispatchQueue.main.async(execute: {
            UIApplication.shared.applicationIconBadgeNumber = 0
        })
    }
}
