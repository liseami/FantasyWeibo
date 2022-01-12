//
//  FeedBackView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import SwiftUI


struct FeedBackView: View {
    var body: some View {
        
        NavigationView {
            Webview(url: feedbackWebUrl)
                .navigationTitle(Text("意见反馈"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: ICON(name: "close"){UIState.shared.showFeedBackView.toggle()})
        }
      
        
    }
}

struct FeedBackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedBackView()
    }
}
