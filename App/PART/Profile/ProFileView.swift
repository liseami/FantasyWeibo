//
//  ProfileView2.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProFileView: View {
    
    
    
    @State private var offset : CGFloat = 0
    @ObservedObject var vm = UserManager.shared
    @ObservedObject var postDC = PostDataCenter.shared
    @State private var backcolor : Color = .clear
    
    // For Dark Mode Adoption..
    @Environment(\.colorScheme) var colorScheme
    // For Smooth Slide Animation...
    @Namespace var animation
    @State var titleOffset: CGFloat = 0
    
    let user : User
    
    init(_ user : User){
        self.user = user
    }
    
    
    var body: some View {
        
        ZStack {
            Color.Card.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack(spacing: 12){
                    
                    banner
                    
                    VStack{
                        //头像
                        avatar
                        
                        //用户信息
                        
                        userinfo
                        
                        
                        // tabbar
                        tabbar

                        //微博
                        posts
                        
                    }
                    // Moving the view back if it goes > 80...
                    .zIndex(-offset > 80 ? 0 : 1)
                }
                
            })
                .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    
    var userinfo : some View {
        VStack(alignment: .leading, spacing: 12, content: {
            let firstline = user.followers_count_str + "关注者 · " +
            user.bi_followers_count + "关注"
            Text(firstline)
                .mFont(style: .Body_15_R,color: .fc2)
            HStack(spacing:12){
                Text(user.name ?? "未知用户")
                    .mFont(style: .large32_B,color: .fc1)
                ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 24)
                    .ifshow(user.verified)
                Spacer()
            }
            if let description = user.description{
                Text(description)
                    .mFont(style: .Body_15_R,color: .fc1)
            }
           
            
            //认证，地理位置
            VStack(alignment: .leading, spacing: 12){
                if let verified_reason = user.verified_reason,user.verified{
                    HStack(spacing:4){
                        ICON(name: "bookmark",size: 16)
                        Text(verified_reason)
                            .lineLimit(1)
                    }
                        .textTag()
                        .PF_Leading()
                }
                if let location = user.location,((user.location ?? "") != "其他") {
                    HStack(spacing:4){
                        ICON(name: "location",size: 16)
                        Text(location)
                    }
                        .textTag()
                }
            }
            .mFont(style: .Body_15_R,color: .fc1)
           
                
            
        })
            .overlay(
                GeometryReader{proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    DispatchQueue.main.async {
                        self.titleOffset = minY
                    }
                    return Color.clear
                }
                    .frame(width: 0, height: 0)
                ,alignment: .top
            )
            .padding(.horizontal,20)
    }
    
    var avatar : some View {
        HStack{
            Spacer()
            WebImage(url: URL(string: user.avatar_large ?? ""))
                .resizable()
                .placeholder {
                    ZStack{
                        Color.Card
                        ProgressView()
                    }
                    .clipShape(Circle())
                }
                .onSuccess { image , data , sd  in
                    getDominantColorsByUIImage(image) { color  in
                        DispatchQueue.main.async {
                            guard backcolor == .clear else {return}
                            self.backcolor = color
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: SW * 0.2, height: SW * 0.2)
                .clipShape(Circle())
                .padding(3.6)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .clipShape(Circle())
                .offset(y: offset < 0 ? getOffset() - 20 : -20)
                .scaleEffect(getScale())
        }
        .padding(.trailing,16)
        .padding(.top,-SW * 0.06)
        .padding(.bottom,-SW * 0.16)
    }
    
    
    var tabbar : some View {
        HStack(spacing:12){
            Text("微博")
            Text("照片")
                .mFont(style: .LargeTitle_22_B,color: .fc3)
            Spacer()
        }
        .mFont(style: .LargeTitle_22_B,color: .fc1)
        .padding(.leading,20)
        .frame(height: GoldenH)
        .background(Color.Card)
        .padding(.top,12)
        .overlay(  Line(),alignment: .bottom)
    }
    
    var posts : some View{
        
        VStack(spacing: 0){
            if let posts = postDC.locuser_profile_posts{
                ForEach(posts,id: \.self.id){post in
//                    TweetCard(post: post)
//                        .padding(.horizontal,6)
//                        .padding(.vertical,6)
//                        .overlay(Rectangle().frame( height: 0.5)
//                                    .foregroundColor(.fc3.opacity(0.3))
//                                 ,alignment: .bottom
//                        )
                }
            }else{
                TextPlaceHolder(text: "暂无微博", subline: "出于第三方Api权限问题，这里最多会显示10条微博。", style: .inline)
                    .padding(.top,44)
            }
        }
    }
    var banner : some View {
        
        // Header View...
        GeometryReader{proxy -> AnyView in
            
            // Sticky Header...
            let minY = proxy.frame(in: .global).minY
            
            DispatchQueue.main.async {
                
                self.offset = minY
            }
            
            return AnyView(
                ZStack{
                    
                    
                    
                    BlurView()
                        .opacity(blurViewOpacity())
                    
                    Color.Card.ignoresSafeArea()
                        .opacity(blurViewOpacity())
                    
                    LinearGradient(gradient: Gradient(colors: [backcolor, backcolor.opacity(0.6)]), startPoint: .bottom, endPoint: .topLeading)
                        .opacity(1 - blurViewOpacity())
                    
                    
                    // Title View...
                    HStack(spacing: 5){
                        
                        // Banner...
                        WebImage(url: URL(string: vm.locUser.avatar_hd ?? ""))
                            .resizable()
                            .placeholder {
                                ZStack{
                                    Color.Card
                                    ProgressView()
                                }
                                .clipShape(Circle())
                            }
                            .scaledToFill()
                            .frame(width: SW * 0.1, height: SW * 0.1)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(lineWidth: 1).foregroundColor(.fc2.opacity(0.2)))
                        
                        Text(vm.locUser.name ?? "")
                            .mFont(style: .Title_17_B,color: .fc1)
                        Text("150 条微博")
                            .mFont(style: .Body_13_R,color: .fc3)
                        Spacer()
                    }
                    .padding(.leading,44)
                    // to slide from bottom added extra 60..
                    .offset(y: 120)
                    .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                    .opacity(titleOffset < 100 ? 1 : 0)
                }
                    .clipped()
                // Stretchy Header...
                    .frame(height: minY > 0 ? 180 + minY : nil)
                    .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
            )
        }
        .frame(height: 180)
        .zIndex(1)
    }
    
    func getTitleTextOffset()->CGFloat{
        
        // some amount of progress for slide effect..
        let progress = 20 / titleOffset
        
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        
        return offset
    }
    
    // Profile Shrinking Effect...
    func getOffset()->CGFloat{
        
        let progress = (-offset / 80) * 20
        
        return progress <= 20 ? progress : 20
    }
    
    func getScale()->CGFloat{
        
        let progress = -offset / 80
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // since were scaling the view to 0.8...
        // 1.8 - 1 = 0.8....
        
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity()->Double{
        let progress = -(offset + 80) / 150
        return Double(-offset > 80 ? progress : 0)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        
        let user = MockTool.readObjectNoKeyPath(User.self, fileName: "locuserprofile")!
        return NavigationView {
            Text("")
                .PF_Navilink(isPresented: .constant(true)) {
                    ProFileView(user)
                }
        }
    }
}
