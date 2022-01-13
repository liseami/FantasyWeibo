//
//  TimeLineView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI
import FantasyUI

struct TimeLineView: View {
    @State private var offset : CGFloat = 0
    @ObservedObject var uistate = UIState.shared
    @ObservedObject var vm = PostDataCenter.shared
    
    let str = randomString(Int.random(in: 12...140))
    
    @State private var isfirstTimeOnAppear : Bool = true
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset, content: {
            
            
            LazyVStack {
                Spacer().frame(width: 1, height: 1)
                
                if !vm.homeTimelinePosts.isEmpty {
                    ForEach(vm.homeTimelinePosts,id:\.self.id){ post in
                        PostRaw(post: post)
                    }
                }else{
                    placeHolder
                }
                
                Spacer().frame(width: 1, height: 80)
            }
            .padding(.all,12)
            
            
        })
            .navigationBarTitleDisplayMode(.inline)
            .PF_Navitop(style:offset < -5 ? .large : .none) {
                BlurView()
            } TopCenterView: {
                Image("Web3Logo")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .scaledToFit()
            }
            .onAppear {
                if isfirstTimeOnAppear {
                    vm.getTimeLine()
                    madasoft()
                    isfirstTimeOnAppear.toggle()
                }
              
            }
        
    }
    
    var placeHolder : some View {
        VStack{
            Spacer()
            TextPlaceHolder(text: "暂无数据", subline: "请尝试刷新数据。",style: .inline)
            MainButton(title: "刷新") {
                vm.getTimeLine()
            }
            Spacer()
            .padding(.horizontal,32)
            Spacer()
        }
        .padding(.horizontal,32)
        
        
    }
    
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(uistate: UIState.init(tabbarIndex: .Timeline, logged: true))
    }
}






