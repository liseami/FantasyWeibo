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
        
        
            
            PF_OffsetScrollView(offset: $offset,refreshingenable: true, refreshAction: { endrefresh in
                //刷新逻辑
                vm.getHomeTimeLine { isSuccess in
                    endrefresh(isSuccess ? .success : .error)
                }
            }, content: {

                LazyVStack {
                    Spacer().frame(width: 1, height: 1)

                    if !vm.home_timeline.isEmpty {
                        //TweetCard 列表
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
        
//        TestTest()
     
     
        .navigationBarTitleDisplayMode(.inline)
        .PF_Navitop(style: offset < -5 ? .large : .none,showDivider: false, backgroundView: {
            BlurView()
        }, TopCenterView: {})
        .onAppear {
            //加载首页数据
            guard vm.home_timeline.isEmpty else {return}
            vm.getHomeTimeLine { isSuccess in
            }
            madasoft()
        }
        
    }

    var placeHolder : some View {
        VStack{
            Spacer()
            TextPlaceHolder(text: "暂无数据", subline: "请尝试刷新数据。",style: .inline)
            MainButton(title: "刷新") {
                vm.getHomeTimeLine { isSuccess in
                }
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






