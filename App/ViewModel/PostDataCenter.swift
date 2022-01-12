//
//  PostDataCenter.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import SwiftUI


class PostDataCenter : ObservableObject{
    static let shared = PostDataCenter()
    
    @Published var timelinedata : TimeLineResponse?
    @Published var posts : [TimeLinePost] = []
    @Published var targetPostId : Int = 0
    @Published var postDetail : PostDetailMod?
    
    func getTimeLine() {
        let target = TimeLineApi.getTimeLinePosts(p: .init())
        Networking.requestArray(target, modeType: TimeLinePost.self, atKeyPath: "statuses") { r, arr in
            if let arr = arr {
                self.posts = arr
            }
        }
    }
    
    func getPostDetail(){
        let target = TimeLineApi.getPostDetail(p: .init(access_token: nil, id: self.targetPostId))
        Networking.requestObject(target, modeType: PostDetailMod.self) { r , mod in
            if let mod = mod {
                self.postDetail = mod
            }
        }
    }
    
}
