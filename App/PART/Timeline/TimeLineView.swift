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
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset, content: {
           
            LazyVStack {

                Spacer().frame(width: 1, height: 1)
                ForEach(0..<12){ index in
                    PostRaw(username: randomString(3), usernickname: "liseami", postcontent: randomString(Int.random(in: 12...140)))
                }
                Spacer().frame(width: 1, height: 80)
            }
            .padding(.all,12)
        })
        .navigationBarTitleDisplayMode(.inline)
        .PF_Navitop(style: .large) {
            BlurView()
        } TopCenterView: {
            Image("Logo")
                .resizable()
                .frame(width: 28, height: 28)
                .scaledToFit()
        }
    }
  
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
