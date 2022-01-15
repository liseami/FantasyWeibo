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
    @Published var targetUserid : String = ""
    
    
    
    //是否登录
    var logged : Bool {
        get{
            guard ProjectConfig.env != .mok else {return true}
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
    var locuid : String {
        get {
            let str =  userDefaults.string(forKey: "loc_uid")
            return str ?? ""
        }
        set{
            objectWillChange.send()
            userDefaults.set(newValue, forKey: "loc_uid")
        }
    }
    
    //LocUserAvatar
    var locAvatarUrl : String{
        get{
            let str =  userDefaults.string(forKey: "locAvatarUrl")
            return str ?? ""
        }
        set{
            objectWillChange.send()
     
            userDefaults.set(newValue, forKey: "locAvatarUrl")
        }
    }
    
    
}


extension UserManager{
    
    
    //获取本地用户信息
    func getlocUser(){
        switch  ProjectConfig.env{
        case .test :
            //根据uid获取用户信息接口
            let target = UserApi.getProfile(p: .init())
            Networking.requestObject(target, modeType: User.self,atKeyPath: nil) { r , user in
                if let user = user {
                    self.locUser = user
                    //本地用户头像持久化
                    guard user.avatar_large != self.locAvatarUrl else { return }
                    self.locAvatarUrl = user.avatar_large ?? ""
                }
            }
        case .mok :
            if let user = MockTool.readObjectNoKeyPath(User.self, fileName: "locuserprofile"){
                self.locUser = user
            }
        }
    }
    
    
    func getProfileData(uid : String?){

        ///确认要请求的id，如果为空，则请求自己的profile
        self.targetUserid = (uid == nil ? self.locuid : uid!)
        
        switch  ProjectConfig.env{
            
        case .test:
            //根据uid获取用户信息接口
            let target = UserApi.getProfile(p: .init(uid:targetUserid))
            Networking.requestObject(target, modeType: User.self,atKeyPath: nil) { r , user in
                if let user = user {
                    self.locUser = user
                    //本地用户头像持久化
                    guard user.avatar_large != self.locAvatarUrl else { return }
                    self.locAvatarUrl = user.avatar_large ?? ""
                }
            }
            
        case .mok:
            if let user = MockTool.readObjectNoKeyPath(User.self, fileName: "remoteuserprofile"){
                self.locUser = user
            }
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
