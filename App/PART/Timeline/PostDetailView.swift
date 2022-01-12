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
    
    var body: some View {
        
        PF_OffsetScrollView(offset: $offset) {
            Group{
                if let post = vm.postDetail{
                    VStack(spacing:24){
                        userline
                        Text(post.text ?? "")
                            .multilineTextAlignment(.leading)
                            .PF_Leading()
                            .lineSpacing(4)
                            .mFont(style: .LargeTitle_22_R,color: .fc1)
                    
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("Tweet"))
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

    
       
    }
    
    @ViewBuilder
    var userline : some View {
        let post = vm.postDetail!
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
            
                VStack(alignment: .leading, spacing:0){
                    Text(post.user?.name ?? "用户名不可见")
                        .mFont(style: .Title_17_B,color: .fc1)
                    Text( post.user?.description ?? "")
                        .mFont(style: .Title_17_R,color: .fc2)
                }
            Spacer()
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
