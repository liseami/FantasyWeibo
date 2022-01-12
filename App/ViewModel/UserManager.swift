//
//  UserManager.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation


class UserManager : ObservableObject {
    static let shared = UserManager()
    let userDefaults = UserDefaults.standard
    
    //是否登录
    var logged : Bool {
        get{
            if let _ =  userDefaults.string(forKey: "access_token"){
                return true
            }else{
                return false
            }
        }
        set{
            objectWillChange.send()
            self.logged = newValue
        }
    }
    
    //Token
    var token : String? {
        get {
            let str =  userDefaults.string(forKey: "access_token")
            return str
        }
        set{
            objectWillChange.send()
            self.logged = true
            userDefaults.set(newValue, forKey: "access_token")
        }
    }
    
}
