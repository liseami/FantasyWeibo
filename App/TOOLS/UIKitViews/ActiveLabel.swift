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
        
        PF_TapTextArea(text: str, tapuser: {username in
            
        }, taptopic: {topicname in
            
        }, tapshorturl: {shorturl in
            
        })
            .overlay(Color.red.opacity(0.1))
            .padding()
            .background(Color.Card)
            .PF_Shadow(color: .fc1, style: .s700)
            .padding()
        
        
    }
}



struct Testtt_Previews: PreviewProvider {
    static var previews: some View {
        Testtt()
    }
}



struct ActiveLabelStack : UIViewRepresentable {
    
    
    @Binding var dynamicHeight: CGFloat
    
    let str : String
    var font : UIFont = MFont(style: .Title_17_R).getUIFont()
    let tapuser : (_ username :String)->()
    let taptopic : (_ topicname : String)->()
    let tapshorturl : (_ shorturl : String)->()
    let label = ActiveLabel()
    
    func makeUIView(context: Context) -> ActiveLabel {
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textAlignment = .left
        
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
            label.font = font
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
                self.tapuser(user)
            }
            
            label.handleCustomTap(for: topictype) { topic in
                print("Success. You just tapped the \(topic) user")
                self.taptopic(topic)
            }
            
            label.handleCustomTap(for: shorturl) { shorturl in
                print("Success. You just tapped the \(shorturl) user")
                self.tapshorturl(shorturl)
            }
        }
        
       
      
      
        
        return label
    }
    func updateUIView(_ uiView: ActiveLabel, context: Context) {
        //动态计算文本的高度....每次渲染只计算一次
        guard self.dynamicHeight == .zero else {return}
        uiView.text = str
        DispatchQueue.main.async {
            dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
        
    }
}



struct PF_TapTextArea : View {
    
    
    var text : String
    var font : UIFont = MFont(style: .Title_17_R).getUIFont()
    let tapuser : (_ username:String)->()
    let taptopic : (_ topicname:String)->()
    let tapshorturl : (_ shorturl:String)->()
    
    @State private  var height : CGFloat = .zero
    
    
    var body: some View{
        
        ActiveLabelStack(dynamicHeight: $height, str: text, font: font, tapuser: {username in
            tapuser(username)
        }, taptopic: {topicname in
            taptopic(topicname)
        }, tapshorturl: {shorturl in
            tapshorturl(shorturl)
        })
        .frame(minHeight: height)
        
    }
}
