//
//  PostView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRaw: View {
 
    
    let post : TimeLinePost
    let avatarW = SW * 0.14
    
    var body: some View {
        HStack(alignment: .top,  spacing:12){
        
            Color.MainColor
                .frame(width: avatarW, height: avatarW)
                .overlay(
                    Group{
                        if let avatarurl = URL(string: post.user?.avatar_large ?? ""){
                            WebImage(url: avatarurl)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                )
                .clipShape(Circle())
            
          
            
            
            VStack(alignment: .leading,spacing:4){
                
                userline
                
                Text(post.text ?? "")
                    .multilineTextAlignment(.leading)
                    .PF_Leading()
                    .mFont(style: .Title_17_R,color: .fc1)
            
                pictures
                    .ifshow(!post.pic_urls.isEmpty)
             
                
                btns
              
                
                
            }
        }
        .padding(.all,12)
        .background(Color.Card)
        .onTapGesture {
            UIState.shared.targetPost = post
            UIState.shared.showPostDetailView = true
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    var pictures : some View {
        Group{
                let urls = post.pic_urls
                let imageW = SW - 24 - 24 - avatarW - 12
            Color.clear.frame(width: imageW, height: imageW * (urls.count == 1 ? 1.4 : 0.618))
                    .overlay(
                        Group{
                            switch post.pic_num{
                            case 1 :
                                
                                WebImage(url: URL(string: post.bmiddle_pic!)!)
                                    .resizable()
                                    .scaledToFill()
                                
                            case 2 : HStack(spacing:1){
                                WebImage(url: URL(string: urls.first!.thumbnail_pic!)!)
                                    .resizable()
                                    .scaledToFill()
                                WebImage(url: URL(string: urls.last!.thumbnail_pic!)!)
                                    .resizable()
                                    .scaledToFill()
                            }
                            case 3 : HStack(spacing:1){
                                WebImage(url: URL(string: urls.first!.thumbnail_pic!)!)
                                    .resizable()
                                    .scaledToFill()
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1].thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls.last!.thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            case 4...12 : HStack(spacing:1){
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls.first!.thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls[2].thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                }
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1].thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls.last!.thumbnail_pic!)!)
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            default:
                                EmptyView()
                            }
                        }
                       
                    )
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    var userline : some View {
        HStack(alignment: .center, spacing:6){
            Text(post.user?.name ?? "用户名不可见")
                .mFont(style: .Title_17_B,color: .fc1)
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
        PostRaw(post: TimeLinePost.init())
            .previewLayout(.sizeThatFits)
        ZStack{
            Color.BackGround.ignoresSafeArea()
            PostRaw(post: TimeLinePost.init())
                .padding(.all,12)
        }
 
       
    }
}
