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
   
    init(tabbarIndex : tabbarItemEnum = .Timeline,logged : Bool = false){
        self.TabbarIndex = tabbarIndex
        
    }
    
    
    // Tabar
    @Published var TabbarIndex : tabbarItemEnum = .Timeline
    @Published var TabbarProgress : Double = 0
    var tabbarItem : [tabbarItemEnum] = [.Timeline,.Search ,.Message,.User]
    
    enum tabbarItemEnum {
        case Timeline
        case Search
        case Message
        case User
        var iconname : String{
            switch self {
            case .Timeline:
                return "home"
            case .Search:
                return "search"
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
    
    
    
    var imageGroup_Height_V : Float {
        get{
            let h = userdefult.float(forKey: "imageGroup_Height_V")
            if h != 0 {
                return h
            }else{
                return Float(0)
            }
        }
        set{
            objectWillChange.send()
            userdefult.set(newValue, forKey: "imageGroup_Height_V")
        }
    }
    
    var imageGroup_Height_H : Float {
        get{
            let h = userdefult.float(forKey: "imageGroup_Height_H")
            if h != 0 {
                return h
            }else{
                return Float(0)
            }
        }
        set{
            objectWillChange.send()
            userdefult.set(newValue, forKey: "imageGroup_Height_H")
        }
    }
    
    var postImageAreaWidth : Float {
        get{
            let h = userdefult.float(forKey: "postImageAreaWidth")
            if h != 0 {
                return h
            }else{
                return Float(0)
            }
        }
        set{
            objectWillChange.send()
            userdefult.set(newValue, forKey: "postImageAreaWidth")
        }
    }
    
}
