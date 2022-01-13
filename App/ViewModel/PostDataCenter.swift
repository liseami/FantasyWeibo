//
//  PostDataCenter.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import SwiftUI


class PostDataCenter :NSObject, ObservableObject,WeiboSDKDelegate{
  
    static let shared = PostDataCenter()
    
    
    @Published var home_timeline : [Post] = []
    @Published var targetPost : Post?
    @Published var user_timeline : [Post] = []
    
    func getHomeTimeLine() {
        switch ProjectConfig.env{
        case .test :
            let target = TimeLineApi.get_home_timeline(p: .init())
            Networking.requestArray(target, modeType: Post.self, atKeyPath: "statuses") { r, arr in
                if let arr = arr {
                    self.home_timeline = arr
                }
            }
        case .mok :
            if let arr = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
                self.home_timeline = arr
            }
        }
    
        
    }
    
    func getProFileTimeLine(){
        
        switch ProjectConfig.env{
        case .test :
            
            let target = TimeLineApi.get_user_timeline(p: .init())
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
    
    
    ///个人主页数据
    func getLocUserTimeLine(){
        WeiboSDK.linkToProfile()
    }
    
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
        print(response)
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
        
    }
    
    
}
