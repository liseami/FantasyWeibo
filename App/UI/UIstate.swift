//
//  UIstate.swift
//  Fantline
//
//  Created by Liseami on 2021/12/14.
//

import SwiftUI

class UIState : ObservableObject{
    
    static let shared = UIState()
    let userdefult = UserDefaults.standard
   
    init(tabbarIndex : tabbarItemEnum = .Timeline,logged : Bool = false,topMediaUrl : [String] = [],showTopMediaArea : Bool = false){
        self.TabbarIndex = tabbarIndex
        self.topImageUrl = topMediaUrl
        self.showTopMediaArea = showTopMediaArea
    }
    
    // Tabar
    @Published var TabbarIndex : tabbarItemEnum = .Timeline
    @Published var TabbarProgress : Double = 0
    var tabbarItem : [tabbarItemEnum] = [.Timeline ,.Message,.User]
    
    enum tabbarItemEnum {
        case Timeline
//        case Search
        case Message
        case User
        var iconname : String{
            switch self {
            case .Timeline:
                return "home"
//            case .Search:
//                return "search"
            case .Message:
                return "notiheart"
            case .User :
                return "user"
            }
        }
    }
    
    ///hometool
    @Published var showSettingView : Bool = false
    @Published var showProfileView : Bool = false
    
    ///post
    @Published var showPostDetailView : Bool = false
    @Published var targetPost : Post = Post.init()
    
    ///Setting
    @Published var showFeedBackView : Bool = false
    
    
    //顶层图片
    @Published var topImageUrl : [String] = []
    @Published var showTopMediaArea : Bool = false
    
    
    
    
    
    
}

extension UIState{
    func getWeiboEmoji() {
        let target = UIApi.getEmoji
        Networking.request(target) { result in
            
        }
    }
    
    
    
    
}


enum UIApi : ApiType{
    
    case getEmoji
    var path: String{
        return "emotions.json"
    }
    
    var method: HTTPMethod{
        .get
    }
    
}
