//
//  ActiveLabel.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/17.
//

import UIKit
import ActiveLabel
import SwiftUI
import FantasyUI
import Alamofire




struct Testtt: View {
    var body: some View {
        let str = "《甄 式 英 语》\n\n#甄式英语# http://t.cn/A6JiyW5g ​"
//        let str = randomString(140)
        
        ScrollView {
            ForEach(0..<12){index in
                
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
     
        
    }
}



struct Testtt_Previews: PreviewProvider {
    static var previews: some View {
        Testtt()
    }
}



struct ActiveLabelStack : UIViewRepresentable {
    
    
    let text : String
    var font : UIFont = MFont(style: .Title_17_R).getUIFont()
    let tapuser : (_ username :String)->()
    let taptopic : (_ topicname : String)->()
    let tapshorturl : (_ shorturl : String)->()
    let label = ActiveLabel()
    
    func makeUIView(context: Context) -> ActiveLabel {
        label.customize { label in
            //样式设置
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.textAlignment = .left

            //高亮正则
            let usertype = ActiveType.custom(pattern: #"@[\u4e00-\u9fa5A-Z0-9a-z_-]{2,30}"#)
            let topictype = ActiveType.custom(pattern: #"#[^@<>#"&'\r\n\t]{1,49}#"#)
            let shorturl = ActiveType.custom(pattern: #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#)
            label.enabledTypes = [usertype,topictype,shorturl]

            //颜色
            label.textColor = UIColor(Color.fc1)
            //字体
            label.font = font
            label.lineSpacing = 4
            
            //可点击文字颜色
            
            label.customColor[usertype] = UIColor(Color.MainColor)
            label.customColor[topictype] = UIColor(Color.MainColor)
            label.customColor[shorturl] = UIColor(Color.Success)
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
        
        let regexweibousers = #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#
        if let shorturls = text.regex(regex: regexweibousers){
            //拿到文字中的图片地址
            
        }
        
            
        label.text = text
        return label
    }
    func updateUIView(_ uiView: ActiveLabel, context: Context) {
        
       

    }
}

protocol ShortUrlApiType: CustomTargetType {
    
}

extension ShortUrlApiType {
    var scheme: String { "http" }
    var host: String { "t.cn"}
    var port: Int? { nil }
    var firstPath: String? { nil}
    var headers: [String: String]? {
        return ["Authorization":"OAuth2" + " " + UserManager.shared.token!]
    }
}

enum ShortUrlApi : ShortUrlApiType{
    case getshorturl(p:String)
    var path: String{
        switch self {
        case .getshorturl(let p):
            return p
        }
    }

    var method: HTTPMethod{
        .get
    }
}



struct PF_TapTextArea : View {
    
    
    var text : String
    var font : UIFont = MFont(style: .Title_17_R).getUIFont()
    let tapuser : (_ username:String)->()
    let taptopic : (_ topicname:String)->()
    let tapshorturl : (_ shorturl:String)->()
    
    var body: some View{
        
        
        LazyVStack(alignment: .leading, spacing: 0) {
            //知道自己有多高的Text
            Text(text)
                .lineSpacing(4)
                .font(Font(font))
                .foregroundColor(.clear) // ---- 👈
                .multilineTextAlignment(.leading)
                .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .leading)
                .overlay( // ---- 👈
                    //不知道自己有多高的  ActiveLabel
                    ActiveLabelStack( text: text, font: font, tapuser: {username in
                        tapuser(username)
                    }, taptopic: {topicname in
                        taptopic(topicname)
                    }, tapshorturl: {shorturl in
                        tapshorturl(shorturl)
                    })
                    ,alignment: .center
                )
        }
      
        
   
       
        
    }
}
