//
//  PostView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI

struct PostRaw: View {
    let username : String
    let usernickname : String
    let postcontent : String
    
    
    
    var body: some View {
        HStack(alignment: .top,  spacing:12){
            
            let avatarW = SW * 0.14
            let imageW = SW - 24 - 32 - avatarW - 12
           
            
            Image("liseamiAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: avatarW, height: avatarW)
                .clipShape(Circle())
            VStack(alignment: .leading,spacing:12){
                
                HStack(alignment: .center, spacing:6){
                    Text(username)
                        .mFont(style: .Title_17_B,color: .fc1)
                    Text("@" + usernickname)
                        .mFont(style: .Title_17_R,color: .fc2)
                    Spacer()
                    
                    Menu {
                        PF_MenuBtn(text: "关注", name: "Like") {
                        }
                    } label: {
                        ICON(sysname: "ellipsis",fcolor: .fc3,size: 16)
                            .padding(.trailing,4)
                    }
                }
                
                Text(postcontent)
                    .multilineTextAlignment(.leading)
                    .PF_Leading()
                    .mFont(style: .Title_17_R,color: .fc1)
            
//              Color.red.frame(width: imageW, height: imageW)
                
                HStack(spacing:SW * 0.2){
                    ICON(name: "message-alt",fcolor:.fc2,size: 20){madasoft()}
                    .buttonStyle(PlainButtonStyle())
                    ICON(name: "enter",fcolor:.fc2,size: 20){madasoft()}
                    .buttonStyle(PlainButtonStyle())
                    ICON(name: "heart",fcolor:.fc2,size: 20){madasoft()}
                    .buttonStyle(PlainButtonStyle())
                }
                
                
            }
        }
        .padding(.all,16)
        .background(Color.Card)
        .onTapGesture {
            UIState.shared.showPostDetailView = true
        }
      
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct PostRaw_Previews: PreviewProvider {
    static var previews: some View {
        PostRaw(username: "Liseami", usernickname: "liseami1", postcontent: randomString(140))
            .previewLayout(.sizeThatFits)
        ZStack{
            Color.BackGround.ignoresSafeArea()
            PostRaw(username: "Liseami", usernickname: "liseami1", postcontent: randomString(140))
                .padding(.all,12)
        }
 
       
    }
}
