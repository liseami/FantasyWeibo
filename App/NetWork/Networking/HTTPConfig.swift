//
//  ApiCenter.swift
//  Cashmix
//
//  Created by 赵翔宇 on 2021/12/18.
//

import FantasyUI
import Foundation


protocol ApiType: CustomTargetType {
    
}

extension ApiType {
    
    var scheme: String { ProjectConfig.scheme }
    var host: String { ProjectConfig.host }
    var port: Int? { ProjectConfig.port }
    var firstPath: String? { ProjectConfig.firstPath }
    

    var headers: [String: String]? {
        return ["Authorization":"OAuth2" + " " + UserManager.shared.token!]
    }

    
}

struct ProjectConfig {
    static let env: Environment = .mok
    
    enum Environment {
    case test, mok
    }
    
    static var scheme: String { "https" }
    
    static var host: String {
        switch env {
        case .test: return "api.weibo.com/2" //
        case .mok: return "api.weibo.com/2" //
        }
    }
    
    static var port: Int? {
        return nil
    }

    
    static var firstPath: String? {
        switch env {
        case .test: return ""
        case .mok: return ""
        }
    }
}

