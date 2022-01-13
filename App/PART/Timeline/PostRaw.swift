//
//  PostView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRaw: View {
 
    
    let post : Post
    let avatarW = SW * 0.14
    
    var body: some View {
        HStack(alignment: .top,  spacing:12){
        
         
          
            UserAvatar(url: URL(string: post.user?.avatar_large ?? ""))
                .canOpenProfile(uid: post.user?.id)
                        
            
            VStack(alignment: .leading,spacing:4){
                
                userline
                
                
                Text(post.text ?? "")
                    .multilineTextAlignment(.leading)
                    .PF_Leading()
                    .mFont(style: .Title_17_R,color: .fc1)
            
                
                
                PostPicsView(urls: post.pic_urls.compactMap({ pic_url in
                    pic_url.thumbnail_pic!
                })).ifshow(!post.pic_urls.isEmpty)
             
                
                btns
              
                
                
            }
        }
        .padding(.all,12)
        .background(Color.Card)
        .onTapGesture {
            PostDataCenter.shared.targetPost = post
            UIState.shared.showPostDetailView = true
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    
    var userline : some View {
        HStack(alignment: .center, spacing:6){
            Text(post.user?.name ?? "用户名不可见")
                .mFont(style: .Title_17_B,color: .fc1)
                .canOpenProfile(uid: post.user?.id)
//            Text("@" + (post.user?.id ?? ""))
//                .mFont(style: .Title_17_R,color: .fc2)
            Spacer()
            
            Menu {
                PF_MenuBtn(text: "关注", name: "Like") {
                }
            } label: {
                ICON(sysname: "ellipsis",fcolor: .fc3,size: 16)
                    .padding(.trailing,4)
            }
        }
    }
    
    var btns : some View{
        HStack(spacing:12){
    
            Spacer()
                .overlay(
                    Button(action: {
                        madasoft()
                    }, label: {
                        HStack(spacing:8){
                            ICON(name: "message-alt",fcolor:.fc2,size: 16)
                            Text(post.comments_count)
                        }
                    })
                    ,alignment: .leading)
            
            Spacer()
                .overlay(
                    Button(action: {
                        madasoft()
                    }, label: {
                        HStack(spacing:8){
                            ICON(name: "enter",fcolor:.fc2,size: 16)
                            Text(post.reposts_count)
                        }
                    })
                    ,alignment: .leading)
            
            Spacer()
                .overlay(
                   
                    Button(action: {
                        madasoft()
                    }, label: {
                        HStack(spacing:8){
                            let liked = post.favorited
                            ICON(name: liked ? "heart.fill" : "heart",fcolor: liked ? .Warning : .fc2,size: 16)
                            Text(post.attitudes_count)
                        }
                    })
                    ,alignment: .leading)
        }
        .mFont(style: .Body_13_R,color: .fc2)
        .padding(.trailing,SW * 0.1)
        .padding(.top,16)
        .padding(.bottom,8)
    }
}

struct PostRaw_Previews: PreviewProvider {
    static var previews: some View {
        PostRaw(post: Post.init())
            .previewLayout(.sizeThatFits)
        ZStack{
            Color.BackGround.ignoresSafeArea()
            PostRaw(post: Post.init())
                .padding(.all,12)
        }
 
       
    }
}



struct goProfileBtn : ViewModifier{
    var uid : String?
    func body(content: Content) -> some View {
        Button {
            UserManager.shared.getProfileData(uid: uid)
            UIState.shared.showProfileView = true
        } label: {
            content
        }
    }
}

extension View{
    func canOpenProfile(uid:String?) -> some View{
        self.modifier(goProfileBtn(uid: uid))
    }
}
