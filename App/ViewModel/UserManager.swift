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
    
    @Published var locUser : User = User.init()
    
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
            userDefaults.set(newValue, forKey: "access_token")
            self.logged = true
        }
    }
    
    //Token
    var locuid : String? {
        get {
            let str =  userDefaults.string(forKey: "loc_uid")
            return str
        }
        set{
            objectWillChange.send()
            userDefaults.set(newValue, forKey: "loc_uid")
        }
    }
    
    
}


extension UserManager{
    func getLocUserProFile(){
        
//        let target = UserApi.getProfile(p: .init(uid:self.locuid))
//        Networking.requestObject(target, modeType: User.self) { r , user in
//            if let user = user {
//                self.locUser = user
//            }
//            print(r.dataJson)
//        }
//
        if let user =  MockTool.readObject(User.self, fileName: "locuserprofile"){
            self.locUser = user
        }
    
    }
}



enum UserApi : ApiType{
    
    case getProfile(p:getProfileReqMod)
    
    var path: String{
        "users/show.json"
    }
    
    var method:HTTPMethod{
        .get
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .getProfile(let p):
            return p.kj.JSONObject()
        }
    }
    
}

struct getProfileReqMod : Convertible{
    var uid : String?
}
