//
//  SettingView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI

public let AppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String


struct SettingView: View {
    
    @ObservedObject var uistate = UIState.shared
    
    var body: some View {
        
        VStack(spacing:0){
            SettingListRow(title: "邀请朋友使用TwitterO3", iconnmae: "Upload")
            SettingListRow(title: "设置", iconnmae: "Gear")
            SettingListRow(title: "账号数据", iconnmae: "List")
            SettingListRow(title: "充值", iconnmae: "database")
            SettingListRow(title: "去AppStore评分", iconnmae: "Smiley")
            SettingListRow(title: "意见反馈邮箱", iconnmae: "Mail")
            SettingListRow(title: "关于TwitterO3", iconnmae: "Link")
            SettingListRow(title: "账户", iconnmae: "Twitter Logo")
            
            versionInfo
        }
        .padding(.all,20)
        .background(Color.Card)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.all,12)
    }
    
    var versionInfo : some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(width: 0, height: 16)
            Text("Version " + AppVersion!)
                .PF_Leading()
                .mFont(style: .Title_17_R,color: .fc3)
            Text("PrueFantasyWeb3 ©️ \(Date().toString(dateFormat: "YYYY"))")
                .mFont(style: .Title_17_R,color: .fc3)
        }
    }
    
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.fc1.opacity(0.3).ignoresSafeArea()
            SettingView()
                .MoveTo(.bottomCenter)
        }
        
    }
}



struct SettingListRow : View {
    let title : String
    let iconnmae : String
    var isNavigation : Bool = true
    
    var body: some View{
        
        HStack(alignment: .center, spacing:20){
            ICON(name: iconnmae,fcolor: .fc1,size: 24)
            Text(title)
                .mFont(style: .Title_17_R,color: .fc1)
            Spacer()
            ICON(name: "Arrow Up",fcolor: .fc3,size: 20)
                .rotationEffect(Angle(degrees: 90))
                .ifshow(isNavigation)
        }
        .padding(.vertical,20)
        
    }
}
