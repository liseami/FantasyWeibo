//
//  PostApis.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation

enum TimeLineApi : ApiType{
    
    case get_home_timeline(p:getTimeLineReqMod)
    case get_user_timeline(p:getUserTimeLineReqMod)
    
    
    var path: String {
        switch self {
        case .get_home_timeline( _):
            return "statuses/home_timeline.json"
        case .get_user_timeline(_):
            return "statuses/user_timeline.json"
        }
        
    }
    
    var method: HTTPMethod{
        .get
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .get_home_timeline(let p):
            return p.kj.JSONObject()
        case .get_user_timeline(p: let p):
            return p.kj.JSONObject()
        }
    }

}

