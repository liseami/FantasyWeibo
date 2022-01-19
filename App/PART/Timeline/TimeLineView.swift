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
    
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset, content: {
            
            LazyVStack {
                Spacer().frame(width: 1, height: 1)
                
                if !vm.home_timeline.isEmpty {
                    ForEach(vm.home_timeline,id:\.self.id){ post in
                        TweetCard(post: post)
                    }
                }else{
                    placeHolder
                }
                
                Spacer().frame(width: 1, height: 80)
            }
            .padding(.all,12)
        })
            .navigationBarTitleDisplayMode(.inline)
            .PF_Navitop(style: offset < -5 ? .large : .none,showDivider: false, backgroundView: {
                BlurView()
            }, TopCenterView: {})
            .onAppear {
                //加载首页数据
                guard vm.home_timeline.isEmpty else {return}
                vm.getHomeTimeLine()
                madasoft()
            }
        
    }
    
    var placeHolder : some View {
        VStack{
            Spacer()
            TextPlaceHolder(text: "暂无数据", subline: "请尝试刷新数据。",style: .inline)
            MainButton(title: "刷新") {
                vm.getHomeTimeLine()
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






