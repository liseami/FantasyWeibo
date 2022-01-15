//
//  Comps.swift
//  Fantline
//
//  Created by Liseami on 2021/12/14.
//

import SwiftUI
import UIKit
import FantasyUI



//MARK: 毛玻璃背景Light
//MARK: 毛玻璃效果
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct BlurView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if colorScheme == .dark {
            return  VisualEffectView(effect: UIBlurEffect(style : .systemChromeMaterialDark))
        } else  {
            return  VisualEffectView(effect: UIBlurEffect(style : .systemChromeMaterialLight))
        }
    }
}


struct TextPlaceHolder: View {
    let text : String
    let subline : String
    var style : styleEnum = .large
    var iconName : String = ""
    
    enum styleEnum {
        case large
        case inline
        case icon
    }
    
    var body: some View {
        switch style {
        case .large:
            VStack(spacing:16){
                Text(LocalizedStringKey(text))
                    .padding(.horizontal,SW * 0.1)
                    .multilineTextAlignment(.center)
                    .mFont(style: .largeTitle_24_B,color: .fc1)
                Text(LocalizedStringKey(subline))
                    .padding(.horizontal,SW * 0.1)
                    .multilineTextAlignment(.center)
                    .mFont(style: .Title_16_R,color: .fc2)
            }
        case .inline:
            VStack(spacing: 6){
                if iconName.isEmpty {
                }else{
                    ICON(name: iconName, fcolor: .fc3, size: SW * 0.618 * 0.618 * 0.618)
                        .padding(.bottom,12)
                }
                Text(LocalizedStringKey(text))
                    .kerning(2)
                    .multilineTextAlignment(.center)
                    .mFont(style: .Title_19_B,color: .fc1)
                Text(LocalizedStringKey(subline))
                    .multilineTextAlignment(.center)
                    .mFont(style: .Body_15_R,color: .fc3)
            }
            .padding(.all, (SW * (1-0.618)) / 2)
            
        case .icon :
            VStack(spacing: 12){
                ICON(name: iconName, fcolor: .fc3, size: 32)
                Text(LocalizedStringKey(text))
                    .kerning(2)
                    .multilineTextAlignment(.center)
                    .mFont(style: .Title_19_B,color: .fc1)
                Text(LocalizedStringKey(subline))
                    .multilineTextAlignment(.center)
                    .mFont(style: .Body_15_R,color: .fc3)
            }
            .padding(.all, (SW * (1-0.618)) / 2)
        }
    }
}

struct TextPlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TextPlaceHolder(text: "暂无回忆条目", subline: "当你添加了回忆，他们将显示在这里。",style: .large)
            TextPlaceHolder(text: "暂无回忆条目", subline: "当你添加了回忆，他们将显示在这里。",style: .inline, iconName: "EmptyBox")
            TextPlaceHolder(text: "暂无回忆条目", subline: "当你添加了回忆，他们将显示在这里。",style: .icon)
        }
        
    }
}



struct EmoText: View {
    var text : String
    var body: some View {
        Text(LocalizedStringKey.init(text))
            .padding(.horizontal,SW * 0.1)
            .multilineTextAlignment(.center)
            .mFont(style: .largeTitle_24_B,color: .fc1)
    }
}


struct Line : View{
    var body: some View{
        Rectangle().frame(height: 0.5).foregroundColor(.back2)
    }
}
