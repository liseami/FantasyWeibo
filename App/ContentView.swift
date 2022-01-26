//
//  ContentView.swift
//  Shared
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI
import SDWebImageSwiftUI
import FantasyUI

struct ContentView: View {
    
    @ObservedObject var uistate = UIState.shared
    @ObservedObject var userManager = UserManager.shared
    
    
    var body: some View {
        
        if !userManager.logged {
            
            LoginView()
            
        }else{
            
            
            NavigationView {
                Group{
                    mainViews
                        .toolbar {toolbar}
                }
                .overlay(Tabbar())
            }
            .overlay(  //顶层媒体
                TopMediaView())
            
            
            
            
            .onAppear(perform: {
                //                uistate.getWeiboEmoji()
                guard userManager.locAvatarUrl.isEmpty else {return}
                //首次登录获取自己的头像等信息
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    userManager.getlocUser()
                }
            })
            .PF_Sheet(isPresented: $uistate.showSettingView, backColor: .clear, content: {
                SettingView()
            })
            .PF_FullScreen(isPresented: $uistate.showFeedBackView, onDismiss: {
            }, content: {
                FeedBackView()
            })
            .accentColor(.fc1)
            .navigationViewStyle(StackNavigationViewStyle())
            .PF_OverProgressView(loadingState: .none)
        }
        
        
    }
    
    ///mainViews
    @ViewBuilder
    var mainViews : some View {
        ZStack{
            Color.BackGround.ignoresSafeArea()
            switch uistate.TabbarIndex{
                ///主页面
            case .Timeline :  TimeLineView()
                //            case .Search   :  searchView
            case .Message   :  InBoxView()
            case .User  :  ProFileView(userManager.locUser)
            }
        }
    }
    
    //    @ViewBuilder
    //    var searchView : some View {
    //        if uistate.TabbarIndex == .Search {
    //            SearchView()
    //                .toolbar {toolbarSearchBtn}
    //        }else{
    //            SearchView()
    //        }
    //    }
    
    
    ///TabbarBtn
    var TabbarBtn : some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button {
                } label: {
                    Circle()
                        .foregroundColor( .MainColor)
                        .frame(width: SW * 0.13, height: SW * 0.13)
                        .overlay(ICON(name: "edit",fcolor: .Card,size: 24))
                        .shadow(color: .fc1.opacity(0.12), radius: 4, x: 0, y: 4)
                }
            }
            .padding(.all, 16)
            .padding(.bottom,GoldenH)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    /// ToolBar
    var toolbar :  some ToolbarContent {
        Group{
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarTrailing
            }
            ToolbarItem(placement: .navigationBarLeading) {
                toolbarLeading
            }
        }
    }
    
    var toolbarSearchBtn : some ToolbarContent {
        ToolbarItem {
            searchBtn
        }
    }
    
    var searchBtn : some View {
        HStack(spacing:2){
            ICON(name: "search",fcolor: .fc2,size: 16)
            Text("搜索新浪微博")
                .mFont(style: .Title_17_R,color: .fc2)
        }
        .padding(.all,12)
        .frame(width: SW * 0.68,height: 32)
        .background(Color.back1
                        .frame(height: 32))
        .clipShape(Capsule(style: .continuous))
        .onTapGesture {
            madasoft()
            SearchManager.shared.showSearchInputView = true
        }
    }
    
    
    var toolbarTrailing : some View {
        
        ICON(name:"settings",fcolor: .fc1){
            uistate.showSettingView.toggle()
        }
        
    }
    
    var toolbarLeading : some View {
        
        ICON(name:"message",fcolor: .MainColor){
            uistate.showFeedBackView.toggle()
        }
        .ifshow(uistate.TabbarIndex != .User)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
