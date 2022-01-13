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
    
    @Published var targetUser : User = User.init()
    @Published var targetUserid : String = ""
    
    
    
    var ismyProfile : Bool{
        targetUserid == locuid
    }
    
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
    
    
    
    func getProfileData(uid : String?){
        
        ///确认要请求的id，如果为空，则请求自己的profile
        self.targetUserid = (uid == nil ? self.locuid! : uid!)
        let requid = uid == nil ? locuid : uid
        self.targetUser = User.init()
        
        
        
        switch  ProjectConfig.env{
            
            
        case .test:
            let target = UserApi.getProfile(p: .init(uid:requid))
            Networking.requestObject(target, modeType: User.self,atKeyPath: nil) { r , user in
                if let user = user {
                    self.targetUser = user
                }
            }
        case .mok:
            if ismyProfile {
                if let user = MockTool.readObjectNoKeyPath(User.self, fileName: "locuserprofile"){
                    self.targetUser = user
                }
            }else{
                if let user = MockTool.readObjectNoKeyPath(User.self, fileName: "remoteuserprofile"){
                    self.targetUser = user
                }
            }
        }
        
        
        
        
        
        //
        
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
