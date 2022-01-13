//
//  PostDataCenter.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import SwiftUI


class PostDataCenter : ObservableObject{
    static let shared = PostDataCenter()
    
    
    @Published var homeTimelinePosts : [Post] = []
    @Published var targetPost : Post?
    
    
    func getTimeLine() {
//        let target = TimeLineApi.getTimeLinePosts(p: .init())
//        Networking.requestArray(target, modeType: TimeLinePost.self, atKeyPath: "statuses") { r, arr in
//            if let arr = arr {
//                self.homeTimelinePosts = arr
//            }
//        }
        
        if let arr = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
            self.homeTimelinePosts = arr
        }
        
    }
    
}
