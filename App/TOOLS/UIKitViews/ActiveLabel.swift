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
                    
                }, tapimage: {shorturl in
                    
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
    var font : UIFont = MFont(style: .Title_17_R).returnUIFont()
    let tapuser : (_ username :String)->()
    let taptopic : (_ topicname : String)->()
    let tapimage : (_ shorturl : String)->()
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
//            let shorturl = ActiveType.custom(pattern: #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#) // 查看图片
//            label.enabledTypes = [usertype,topictype,shorturl]
            label.enabledTypes = [usertype,topictype]
            
            //颜色
            label.textColor = UIColor(Color.fc1)
            //字体
            label.font = font
            label.lineSpacing = 4
            
            //可点击文字颜色
            
            label.customColor[usertype] = UIColor(Color.MainColor)
            label.customColor[topictype] = UIColor(Color.MainColor)
//            label.customColor[shorturl] = UIColor(Color.MainColor)
            label.customSelectedColor[usertype] = UIColor(Color.MainColorSelected)
            label.customSelectedColor[topictype] = UIColor(Color.MainColorSelected)
//            label.customSelectedColor[shorturl] = UIColor(Color.MainColorSelected)
            
            label.handleCustomTap(for: usertype) { user  in
                print("Success. You just tapped the \(user) user")
                self.tapuser(user)
            }
            
            label.handleCustomTap(for: topictype) { topic in
                print("Success. You just tapped the \(topic) user")
                self.taptopic(topic)
            }
            
//            label.handleCustomTap(for: shorturl) { image in
//                print("Success. You just tapped the \(image) image")
//                self.tapimage(image)
//            }
        }
        
        
         
        let atttext = NSMutableAttributedString(string: text)
//
        
//        if let ganggangrange:[NSRange] = getRangesByRegex(regex: #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#, text: text) {
//
//            for range in ganggangrange {
//                var cutoffLocation = text.length
//            atttext.addAttributes(
//                    [NSAttributedString.Key.link :"https://githu",
//                     NSAttributedString.Key.foregroundColor : UIColor(Color.red)
//                    ], range: range)
////                如果最多字符个数会截断高亮字符，则舍去高亮字符
//                if cutoffLocation >= range.location && cutoffLocation <= range.location + range.length {
//                    cutoffLocation = range.location
//                }
//            }
//
//        }
        
        atttext.addAttributes([
            NSAttributedString.Key.link :"https://www.baidu.com",
                               NSAttributedString.Key.foregroundColor : UIColor(Color.green)
                              ], range: NSRange(location: 0, length: text.length))

        label.attributedText = atttext
        
        label.isUserInteractionEnabled = true

        
        
        return label
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject,UITextViewDelegate {
        var parent: ActiveLabelStack
        
        init(_ parent: ActiveLabelStack) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if let str = URL.scheme?.utf8CString{
                print("🐼🐼🐼🐼")
                print(str)
                print("🐼🐼🐼🐼")
                return true
            }
            else{
                return false
            }
        }
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
    var font : UIFont = MFont(style: .Title_17_R).returnUIFont()
    let tapuser : (_ username:String)->()
    let taptopic : (_ topicname:String)->()
    let tapimage : (_ shorturl:String)->()
    
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
                    }, tapimage: {shorturl in
                        tapimage(shorturl)
                    })
                    ,alignment: .center
                )
        }
        
        
        
        
        
    }
}



//正则替换
func regexPattern(pattern:String,str:String,withTemplate:String) -> String {
    
    var finalStr = str
    
    do {
        
        // - 1、创建规则
        let pattern = pattern
        // - 2、创建正则表达式对象
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        
        // - 3、正则替换
        finalStr = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count), withTemplate: withTemplate)
        
        //            获取满足条件的集合
        //            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, content.characters.count))
        
    }
    catch {
        print(error)
    }
    
    return finalStr
    
}
