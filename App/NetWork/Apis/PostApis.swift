//
//  PostApis.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation

enum PostApi : ApiType{
    
    case get_home_timeline(p:getTimeLineReqMod)
    case get_user_timeline(p:getUserTimeLineReqMod)
    case get_post_comments(p:getPostCommentsReqMod)
    case get_user_mentions(p:getUserMentionsReqMod)
    case get_user_comments_mentions(p:getUserCommentsMentionsReqMod)
    
    var path: String {
        switch self {
        case .get_home_timeline( _):
            return "statuses/home_timeline.json"
        case .get_user_timeline(_):
            return "statuses/user_timeline.json"
        case .get_post_comments( _):
            return  "comments/show.json"
        case .get_user_mentions(p: _):
            return "statuses/mentions.json"
        case .get_user_comments_mentions(p: _):
            return "comments/mentions.json"
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
        case .get_post_comments(p: let p):
            return p.kj.JSONObject()
        case .get_user_mentions(p: let p):
            return p.kj.JSONObject()
        case .get_user_comments_mentions(p: let p):
            return p.kj.JSONObject()
        }
    }

}

