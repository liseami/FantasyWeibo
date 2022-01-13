//
//  File.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//


import SwiftUI

class SearchManager : ObservableObject{
    
    static let shared  = SearchManager()
    
    @Published var showSearchInputView : Bool = false
    
    
    enum searchResultSwitch : MTPageSegmentProtocol {
        case top
        case latest
        case people
        case photos
        case videos
        case space
       
        var showText: String{
            switch self {
            case .top:
               return "热门"
            case .latest:
                return "最新"
            case .people:
                return "用户"
            case .photos:
                return "照片"
            case .videos:
                return "视频"
            case .space:
                return "空间"
            }
        }
    }
    
    @Published var searchResultTab : searchResultSwitch = .top
    var tabitems : [searchResultSwitch] = [.top,.latest,.people,.photos,.videos,.space]
}



