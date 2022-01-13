//
//  ProFileView.swift
//  Fantline
//
//  Created by 赵翔宇 on 2021/12/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProFileView: View {
    
    @State private var backcolor : Color = .BackGround
    @State private var offset : CGFloat = 0
    @ObservedObject var vm = UserManager.shared
    let loc : Bool = true
    
    var body: some View {
        
        
        ZStack
        {
            Color.BackGround.ignoresSafeArea()
            
            
            if backcolor != .BackGround{
                LinearGradient(gradient: Gradient(colors: [backcolor, backcolor.opacity(0)]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                    .animation(.spring(), value: backcolor)
                    .transition(.move(edge: .top))
            }
            
            BlurView().ignoresSafeArea()
            
            
            
            PF_OffsetScrollView(offset: $offset) {
                
                VStack(spacing:32){
                    
                    VStack(spacing:12){
                        avatar
                        
                        Text(vm.locUser.name ?? "...")
                            .mFont(style: .LargeTitle_22_B,color: .fc1)
                        
                        
                        Group{
                            if let verified_reason = vm.locUser.verified_reason{
                                Text(verified_reason)
                            }
                        }
                        .mFont(style: .Body_15_B,color: .fc1)
                        .padding(.horizontal,32)
                        .padding(.vertical,6)
                        .background(Color.fc3.opacity(0.2))
                        .clipShape(Capsule(style: .continuous))
                    }
                    
                    HStack(spacing:SW * 0.12){
                        
                        VStack{
                            Text(vm.locUser.status_total_counter?.comment_cnt ?? "0")
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("照片")
                        }
                        
                        VStack{
                            Text(vm.locUser.statuses_count)
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("微博")
                        }
                        
                        VStack{
                            Text(vm.locUser.followers_count)
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("粉丝")
                        }
                        
                        VStack{
                            Text(vm.locUser.bi_followers_count)
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("关注")
                        }
                        
                    }
                    .mFont(style: .Body_15_R,color: .fc2)
                    
                    
                    Spacer()
                }
                .padding(.all,24)
            }
            
            
            
        }
        .onAppear(perform: {
            vm.getLocUserProFile()
        })
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    @ViewBuilder
    var avatar : some View {
        let imageurl = URL(string: vm.locUser.avatar_large ?? "")
        
        WebImage(url: imageurl)
            .resizable()
            .placeholder(content: {
                Color.Card
                    .frame(width: SW * 0.3,height: SW * 0.3)
                    .clipShape(Circle())
                    .overlay(ProgressView())
            })
            .scaledToFill()
            .frame(width: SW * 0.3,height: SW * 0.3)
            .clipShape(Circle())
            .onAppear {
                let uiimage =  WebImage(url: imageurl).asUIImage()
                getDominantColorsByUIImage(uiimage) { color  in
                    DispatchQueue.main.async {
                        madasoft()
                        withAnimation {
                            self.backcolor = color
                        }
                    }
                }
            }
        
    }
    
    
    
}

struct ProFileView_Previews: PreviewProvider {
    static var previews: some View {
        ProFileView()
    }
}
