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
   
    init(tabbarIndex : tabbarItemEnum = .Timeline){
        self.TabbarIndex = tabbarIndex
    }
    
    @Published var logged : Bool = false
    // Tabar
    @Published var TabbarIndex : tabbarItemEnum = .Timeline
    @Published var TabbarProgress : Double = 0
    var tabbarItem : [tabbarItemEnum] = [.Timeline,.Poluar,.Search,.Message]
    
    enum tabbarItemEnum {
        case Timeline
        case Search
        case Message
        case Poluar
        var iconname : String{
            switch self {
            case .Timeline:
                return "home"
            case .Search:
                return "search"
            case .Message:
                return "email"
            case .Poluar :
                return "bar-chart-alt"
            }
        }
    }
    
    ///hometool
    @Published var showSettingView : Bool = false
    @Published var showProfileView : Bool = false
    
    ///post
    @Published var showPostDetailView : Bool = false
    
}
