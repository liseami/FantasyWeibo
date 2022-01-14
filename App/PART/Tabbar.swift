//
//  Tabbar.swift
//  Fantline
//
//  Created by Liseami on 2021/12/14.
//

import SwiftUI

struct Tabbar: View {
    @ObservedObject var uistate = UIState.shared
    
    var body: some View {
        
            HStack{
                ForEach(uistate.tabbarItem,id: \.self){ tabitem in
                    let selected = tabitem == uistate.TabbarIndex
                    let iconname = tabitem.iconname
                    Button {
                        if tabitem == .User{
                            UserManager.shared.getProfileData(uid: nil)
                            PostDataCenter.shared.getProFileTimeLine()
                        }
                        uistate.TabbarIndex = tabitem
                    } label: {
                        Rectangle()
                      .hidden()
                      .overlay(
                        Group{
                            if tabitem == .User{
                                //用户展示头像
                                if UserManager.shared.locAvatarUrl.isEmpty{
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(.fc1)
                                        .frame(width: 28, height: 28)
                                }else{
                                    let url = URL(string: UserManager.shared.locAvatarUrl)
                                    UserAvatar(url: url, frame: 28)
                                        .clipShape(Circle())
                                }
                            }else{
                                ICON(name: selected ? iconname + ".selected" : iconname,
                                            fcolor: .fc1,
                                            size: 28).disabled(true)
                            }
                        }
                      )
                    }
                }
            }
            .padding(.horizontal,20)
            .background(
                ZStack{
                    Color.back1.opacity(0.3).ignoresSafeArea()
                    BlurView().ignoresSafeArea()
                }
                )
            .frame( height: GoldenH - 8,alignment: .center)
            .overlay(Rectangle().foregroundColor(.fc2).opacity(0.1).frame( height: 0.5),alignment: .top)
            .overlay(
            ProgressView.init(value:uistate.TabbarProgress )
                .progressViewStyle(LinearProgressViewStyle(tint: Color.MainColor))
                .frame(height: 0.5)
                .ifshow(uistate.TabbarProgress != 0),alignment: .top)
            .background(Color.Card.ignoresSafeArea())
            .MoveTo(.bottomCenter)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}

struct Tabbar_Previews: PreviewProvider {
    static var previews: some View {
        Tabbar()
    }

}
