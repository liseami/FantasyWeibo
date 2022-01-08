//
//  ContentView.swift
//  Shared
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var uistate = UIState.shared
    
    
    var body: some View {
        
    
        if !uistate.logged {
            LoginView()
        }else{
            NavigationView {
                if #available(iOS 15.0, *) {
                    mainViews
                    ///Toolbar
                    .toolbar {toolbar}
                }else{
                    mainViews
                    .navigationBarItems(leading: toolbarLeading, trailing: toolbarTrailing)
                }
            }
            .overlay(Tabbar())
            .overlay(TabbarBtn)
            .PF_Sheet(isPresented: $uistate.showSettingView, backColor: .clear, content: {
                SettingView()
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
            case .Poluar   :  PolularView()
            case .Search   :  searchView
            case .Message  :  InBoxView()
            }
        }
        ///Navilink
        ///个人主页
        .PF_Navilink(isPresented: $uistate.showProfileView) {
            ProFileView()
        }
        ///Post详情
        .PF_Navilink(isPresented: $uistate.showPostDetailView, content: {
            PostDetailView()
        })
    }
    
    @ViewBuilder
    var searchView : some View {
        if uistate.TabbarIndex == .Search {
            SearchView()
                .toolbar {toolbarSearchBtn}
        }else{
            SearchView()
        }
    }
    
    
    ///TabbarBtn
    var TabbarBtn : some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button {
                } label: {
                    let poluar = uistate.TabbarIndex == .Poluar
                    Circle()
                        .foregroundColor( poluar ? .Purple : .MainColor)
                        .frame(width: SW * 0.13, height: SW * 0.13)
                        .overlay(ICON(name: poluar ? "upup" : "Plus add",fcolor: .Card,size: 24))
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
                ICON(name: "Search",fcolor: .fc2,size: 16)
                    Text("搜索Twitter")
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
        Button {
            uistate.showSettingView.toggle()
        } label: {
            ICON(name:"Gear",fcolor: .fc1){
                uistate.showSettingView.toggle()
            }
        }
    }
    
    var toolbarLeading : some View {
        HStack(spacing:18){
            Button {
                uistate.showProfileView.toggle()
            } label: {
                PF_AsyncImage(UIImage(named: "liseamiAvatar"))
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            
            if #available(iOS 15.0, *) {
                EmptyView()
            }else{
                searchBtn
                    .ifshow(uistate.TabbarIndex == .Search)
            }
            
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
