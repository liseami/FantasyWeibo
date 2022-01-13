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
    
    var body: some View {
        
        let user  = vm.targetUser
        let wegimage =  WebImage(url: URL(string: user.avatar_large ?? ""))
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
        
        
        ZStack {
            Color.Card.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack(spacing: 15){
                    
                    header
                    
                    
                    
                    VStack{
                        
                        
                        HStack{
                            
                            Spacer()
                            wegimage
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
                        
                        // Profile Data...
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            
                            
                            let firstline = user.followers_count_str + "粉丝 · " +
                            user.bi_followers_count + " 关注"
                            Text(firstline)
                                .mFont(style: .Body_15_R,color: .fc2)
                            
                            Text(user.name ?? "未知用户")
                                .PF_Leading()
                                .mFont(style: .large32_B,color: .fc1)
                            
                            
                            
                            Text(user.description ?? "")
                            
                            HStack(spacing: 5){
                                Text(user.location ?? "")
                                    .mFont(style: .Body_15_B,color: .fc1)
                                    .padding(.horizontal,12)
                                    .padding(.vertical,6)
                                    .background(Color.back1.opacity(0.6))
                                    .clipShape(Capsule(style: .continuous))
                                
                            }
                            .padding(.top,8)
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
                        
                        
                        // Custom Segmented Menu...

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
                        
                        
                        
                        VStack(spacing: 0){

                            if !postDC.user_timeline.isEmpty{
                                let posts = postDC.user_timeline
                                ForEach(posts,id: \.self.id){post in
                                    
                                    PostRaw(post: post)
                                        .padding(.horizontal,6)
                                        .padding(.vertical,6)
                                        .overlay(Rectangle().frame( height: 0.5)
                                                    .foregroundColor(.fc3.opacity(0.3))
                                                 ,alignment: .bottom
                                        )
                                }
                                
                            }else{
                                Text("暂无数据")
//                                ForEach(0...12,id: \.self){index  in
//                                    PostRaw(post: Post.init())
//                                        .padding(.horizontal,20)
//                                        .padding(.vertical,6)
//                                        .overlay(Rectangle().frame( height: 0.5)
//                                                    .foregroundColor(.fc3.opacity(0.3))
//                                                 ,alignment: .bottom
//                                        )
//
//
//                                }
                                
                            }
                           
                            
                        }
                        
                        .padding(.top)
                        .zIndex(0)
                    }
                    
                    
                    // Moving the view back if it goes > 80...
                    .zIndex(-offset > 80 ? 0 : 1)
                }
                
            })
                .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    
    var header : some View {
     
        // Header View...
        GeometryReader{proxy -> AnyView in
            
            // Sticky Header...
            let minY = proxy.frame(in: .global).minY
            
            DispatchQueue.main.async {
                
                self.offset = minY
            }
            
            return AnyView(
                ZStack{
                    
                    LinearGradient(gradient: Gradient(colors: [backcolor, backcolor.opacity(0.6)]), startPoint: .bottom, endPoint: .topTrailing)
                    
                    BlurView()
                        .opacity(blurViewOpacity())
                    
                    Color.Card.ignoresSafeArea()
                        .opacity(blurViewOpacity())
                    
                    // Title View...
                    HStack(spacing: 5){
                        
                        // Banner...
                        WebImage(url: URL(string: vm.targetUser.cover_image ?? ""))
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
                        
                        Text(vm.targetUser.name ?? "")
                            .mFont(style: .Title_17_B,color: .fc1)
                        Text("150 条微博")
                            .mFont(style: .Body_13_R,color: .fc3)
                        Spacer()
                    }
                    .padding(.leading,UserManager.shared.ismyProfile ? 16 :  44)
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
        
        NavigationView {
            Text("")
                .PF_Navilink(isPresented: .constant(true)) {
                    ProFileView()
                        .onAppear {
                            if let user = MockTool.readObjectNoKeyPath(User.self, fileName: "remoteuserprofile"){
                                UserManager.shared.targetUser = user
                                
                            }
                        }
                }
        }
        
        
    }
}
