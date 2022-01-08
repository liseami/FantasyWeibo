//
//  PostDetailView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import FantasyUI

struct PostDetailView: View {
    @State private var offset : CGFloat = 0
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset) {
            VStack(spacing:24){
                HStack(alignment: .top,  spacing:12){
                    Image("liseamiAvatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: SW * 0.12, height: SW * 0.12)
                        .clipShape(Circle())
                    
                        VStack(alignment: .leading, spacing:0){
                            Text("Liseami")
                                .mFont(style: .Title_17_B,color: .fc1)
                            Text("@" + "usernickname")
                                .mFont(style: .Title_17_R,color: .fc2)
                        }
                    Spacer()
                }
       
                
                Text(randomString(140))
                    .multilineTextAlignment(.leading)
                    .PF_Leading()
                    .lineSpacing(4)
                    .mFont(style: .LargeTitle_22_R,color: .fc1)
            
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Tweet"))
            .padding(.all,16)
        }
        .PF_Navitop(style:offset < -5 ? .large : .none) {
            BlurView()
        } TopCenterView: {
            EmptyView()
        }

    
       
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
