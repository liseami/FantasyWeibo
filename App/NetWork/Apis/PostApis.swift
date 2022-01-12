//
//  PostApis.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation

enum TimeLineApi : ApiType{
    
    case getTimeLinePosts(p:getTimeLineReqMod)
    case getPostDetail(p:getPostDetailReqMod)
    
    
    var path: String {
        switch self {
        case .getTimeLinePosts( _):
            return "statuses/home_timeline.json"
        case .getPostDetail(_):
            return "statuses/show.json"
        }
        
    }
    
    var method: HTTPMethod{
        .get
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .getTimeLinePosts(let p):
            return p.kj.JSONObject()
        case .getPostDetail(p: let p):
            return p.kj.JSONObject()
        }
    }

}

