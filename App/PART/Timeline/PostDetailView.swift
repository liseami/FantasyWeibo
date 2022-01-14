//
//  PostDetailView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import FantasyUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    
    @State private var offset : CGFloat = 0
    let avatarW = SW * 0.14
    @ObservedObject var vm = PostDataCenter.shared
    
    @State private var comment : String = ""
    var body: some View {
        
        ZStack{
            
  
        PF_OffsetScrollView(offset: $offset) {
            Group{
                if let post = vm.targetPost{
                    VStack(spacing:24){
                        userinfoline
                        
                        Text(post.text ?? "")
                            .multilineTextAlignment(.leading)
                            .PF_Leading()
                            .lineSpacing(4)
                            .mFont(style: .LargeTitle_22_R,color: .fc1)
                    
                        PostPicsView(urls: post.pic_urls.compactMap({ pic_url  in
                            getbmiddleImageUrl(urlString: pic_url.thumbnail_pic!)
                        }))
                            .ifshow(!post.pic_urls.isEmpty)
                        
                        
                        HStack(spacing:20){
                            ForEach(vm.posttoolbtns,id :\.self){ tool in
                                HStack(spacing:6){
                                    Text(tool == .comment ? post.comments_count : tool == .repost ? post.reposts_count : post.attitudes_count)
                                        .mFont(style: .Title_17_B,color: .fc1)
                                    Text(tool.title)
                                        .mFont(style: .Body_15_R,color: .fc2)
                                }
                            }
                            Spacer()
                        }
                        
                        
                        HStack(spacing:20){
                            ForEach(vm.posttoolbtns,id : \.self){ toolbtn in
                                Spacer()
                                    .frame( height: GoldenH)
                                    .overlay(ICON(name:toolbtn.iconname,fcolor: .fc2))
                            }
                        }
                        .overlay(   Line(),alignment: .top)
                        .overlay(   Line(),alignment: .bottom)
                        
                        
                     
                     
                        
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("详情"))
                    .padding(.all,16)
                }else{
                    ProgressView()
                }
            }
        }
        .PF_Navitop(style:offset < -5 ? .large : .none) {
            BlurView()
        } TopCenterView: {
            EmptyView()
        }

            
    
            
            
            
            
            
            
            
            
            HStack{
                UserAvatar(url: URL(string: UserManager.shared.locAvatarUrl),frame: GoldenH)
                TextField("添加评论...", text: $comment)
                    .mFont(style: .Body_15_R,color: .fc1)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal,12)
                    .frame( height: GoldenH)
                    .overlay(Capsule(style: .continuous).stroke(lineWidth: 0.5).foregroundColor(.fc3.opacity(0.3)))
            }
            .padding(.all,12)
            .overlay(Line(),alignment: .top)
            .background(Color.Card.ignoresSafeArea())
            .MoveTo(.bottomCenter)
            
            
      
        
            
        }
    }
    
    @ViewBuilder
    var userinfoline : some View {
        let post = vm.targetPost!
        HStack(alignment: .top,  spacing:12){
           
                UserAvatar(url: URL(string: post.user?.avatar_large ?? ""))
                VStack(alignment: .leading, spacing:0){
                    Text(post.user?.name ?? "用户名不可见")
                        .mFont(style: .Title_17_B,color: .fc1)
                 
                    
                    Text(getUserInfoSubLine())
                        .lineLimit(1)
                        .mFont(style: .Title_17_R,color: .fc2)
                    
                }
            Spacer()
        }
    }
    
    func getUserInfoSubLine() -> String{
        let post = vm.targetPost!
        if let description = post.user?.description{
            return description
        }
        if let location =  post.user?.location{
            return location
        }
        return "/"
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("")
                .PF_Navilink(isPresented: .constant(true)) {
                    PostDetailView()
                        .onAppear {
                            if let posts = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
                                let post = posts.randomElement()
                                PostDataCenter.shared.targetPost = post
                            }
                        }
                }
        }
    }
}
