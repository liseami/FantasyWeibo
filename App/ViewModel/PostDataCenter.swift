//
//  PostDataCenter.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import SwiftUI


class PostDataCenter :NSObject, ObservableObject,WeiboSDKDelegate{
  
    static let shared = PostDataCenter()
    var posttoolbtns : [postToolBtn] = [.comment,.repost,.attitude]
    
    @Published var home_timeline : [Post] = []
    @Published var user_timeline : [Post] = []
    
    
    
   
    
    //首页时间线
    func getHomeTimeLine() {
        DispatchQueue.global().async {
            switch ProjectConfig.env{
            case .test :
                let target = PostApi.get_home_timeline(p: .init(count:57))
                Networking.requestArray(target, modeType: Post.self, atKeyPath: "statuses") { r, arr in
                    if let arr = arr {
                        DispatchQueue.main.async {
                            self.home_timeline = arr
                        }
                    }
                }
            case .mok :
                if let arr = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
                    DispatchQueue.main.async {
                        self.home_timeline = arr
                    }
                }
            }
        }
      
    }
    
    //个人主页时间线
    func getProFileTimeLine(){
        switch ProjectConfig.env{
        case .test :
            let target = PostApi.get_user_timeline(p: .init(uid:UserManager.shared.locuid))
            Networking.requestArray(target, modeType: Post.self,atKeyPath: "statuses") { r , arr  in
                if let arr = arr {
                    self.user_timeline = arr
                }
            }
        case .mok:
            if let arr = MockTool.readArray(Post.self, fileName: "profiletimeline", atKeyPath: "statuses"){
                self.user_timeline = arr
            }
        }
    }
    

    
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
    }
    
    
    //互动工具
    enum postToolBtn {
        case comment
        case repost
        case attitude
        var iconname : String{
            switch self {
            case .comment:
                return "message"
            case .repost:
                return "enter"
            case .attitude:
                return "heart"
            }
        }
        var title : String{
            switch self {
            case .comment:
                return "评论"
            case .repost:
                return "转发"
            case .attitude:
                return "赞"
            }
        }
    }
    
    
    
    
    
    
}
