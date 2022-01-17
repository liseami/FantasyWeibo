//
//  ActiveLabel.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/17.
//

import UIKit
import ActiveLabel
import SwiftUI




struct Testtt: View {
    var body: some View {
        let str = "甄 式 英 语》\n\n#甄式英语# http://t.cn/A6JiyW5g ​"
        
        
        Text(str)
            .lineSpacing(2)
            .mFont(style: .Title_17_R,color: .red)
            .overlay(Color.red.opacity(0.3))
            .overlay(

                ActiveLabelTest(str: str) {
                    //点击用户
                    
                } taptopic: {
                    //点击标签
                    
                } tapshorturl: {
                    //点击短链接
                    
                }
                
            )
        
        
        
    }
}



struct Testtt_Previews: PreviewProvider {
    static var previews: some View {
        Testtt()
    }
}



struct ActiveLabelTest : UIViewRepresentable {
    
    let str : String
    let tapuser : ()->()
    let taptopic : ()->()
    let tapshorturl : ()->()
    
    func makeUIView(context: Context) -> UILabel {
        
        
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        label.customize { label in
            //高亮正则
            let usertype = ActiveType.custom(pattern: #"@[\u4e00-\u9fa5A-Z0-9a-z_-]{2,30}"#)
            let topictype = ActiveType.custom(pattern: #"#[^@<>#"&'\r\n\t]{1,49}#"#)
            let shorturl = ActiveType.custom(pattern: #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#)
            label.enabledTypes = [usertype,topictype,shorturl]
            //文字
            label.text = str
            //颜色
            label.textColor = UIColor(Color.fc1)
            //字体
            label.font = MFont(style: .Title_17_R).getUIFont()
            label.lineSpacing = 2
            //可点击文字颜色
            label.customColor[usertype] = UIColor(Color.MainColor)
            label.customColor[topictype] = UIColor(Color.MainColor)
            label.customColor[shorturl] = UIColor(Color.MainColor)
            label.customSelectedColor[usertype] = UIColor(Color.MainColorSelected)
            label.customSelectedColor[topictype] = UIColor(Color.MainColorSelected)
            label.customSelectedColor[shorturl] = UIColor(Color.MainColorSelected)
          
            label.handleCustomTap(for: usertype) { user  in
                print("Success. You just tapped the \(user) user")
                self.tapuser()
            }
            
            label.handleCustomTap(for: topictype) { topic in
                print("Success. You just tapped the \(topic) user")
                self.taptopic()
            }
            
            label.handleCustomTap(for: shorturl) { shorturl in
                print("Success. You just tapped the \(shorturl) user")
                self.tapshorturl()
            }
        

        }
        
        return label
    }
    func updateUIView(_ uiView: UILabel, context: Context) {
        
    }
}



struct PF_TapTextArea : View {
    
    var text : String
    let tapuser : ()->()
    let taptopic : ()->()
    let tapshorturl : ()->()
    
    
    var body: some View{
        
        Text(text)
            .lineSpacing(2)
            .mFont(style: .Title_17_R,color: .Card)
            .overlay(
                ActiveLabelTest(str: self.text) {
                    //点击用户
                    tapuser()
                } taptopic: {
                    //点击标签
                    taptopic()
                } tapshorturl: {
                    //点击短链接
                    tapshorturl()
                }
                    .clipped()
                ,alignment : .top
            )
        
    }
}


//
//struct TapTextConfig {
//    let type : ActiveType
//    var color : Color = .MainColor
//    var action : ()->()
//}
