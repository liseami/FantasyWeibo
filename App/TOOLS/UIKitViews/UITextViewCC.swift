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
import BSText




struct TextViewCCView: View {
    
    
    @State  var h : CGFloat = 0
    
    var body: some View {
        let str = "http://t.cn/A6JitJdF //@鸡老师的肉身:awsl//@月刊勇者KuMa君:http://t.cn/A6JitJdF //@LatteKuroba://@月见冥://@魔剑#士达纳托斯的#苦痛:我恋爱了//@妖幺漆_并不努力: 大写的无敌[抱一抱]"
        //        let str = randomString(140)
        
        
        
        VStack{

            GeometryReader { geo in
                let w = geo.size.width
                ScrollView {
                    ForEach(0..<12){index in
                        
                        
                        uitextViewCC(text: str, fixedWidth: w - 24 * 2)
//                            .frame( minHeight: h)
                            .padding(.all,12)
                            .background(Color.Card    .shadow(color: .fc1.opacity(0.1), radius: 24, x: 0, y: 0))
                            .padding(.all,12)
                       
                        
                        
                        //
                        
                    }
                }
            }
         
        }
   
        
        
    }
}



struct TextViewCCView_Previews: PreviewProvider {
    static var previews: some View {
        TextViewCCView()
    }
}



extension ActiveLabel{
    
}

struct uitextViewCC : UIViewRepresentable {
    
    
    
    let text : String
    let textView = UITextView(frame: .zero)
//    @Binding var height : CGFloat
    var fixedWidth: CGFloat
    
    class Coordinator: NSObject, UITextViewDelegate {
           var parent: uitextViewCC
           init(_ parent: uitextViewCC) {
               self.parent = parent
           }
       }
    
    func makeCoordinator() -> Coordinator {
           return Coordinator(self)
       }
    
    func makeUIView(context: Context) -> UITextView {
        
             let padding = textView.textContainer.lineFragmentPadding
             textView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
             textView.isScrollEnabled = false
             textView.backgroundColor = .clear // just to make it easier to see
             textView.delegate = context.coordinator
             textView.translatesAutoresizingMaskIntoConstraints = false
             textView.widthAnchor.constraint(equalToConstant: fixedWidth).isActive = true //<--- Here
             textView.isEditable = false
        
             return textView
        
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            let res = matchesResultOfTitle(text: text, expan: false)
//            self.height = res.height
            textView.attributedText = res.attributedString
        }
    }
    
    func matchesResultOfTitle(text : String,expan : Bool) -> (attributedString : NSMutableAttributedString ,height : CGFloat){
        
        
        let userRegex =  #"@[\u4e00-\u9fa5A-Z0-9a-z_-]{2,30}"#
        let topicRegex =  #"#[^@<>#"&'\r\n\t]{1,49}#"#
        let shorturlRegex =  #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#
        
        //富文本
        var attributedString:NSMutableAttributedString = NSMutableAttributedString(string: text)
        //富文本范围
        var textRange = NSRange(location: 0, length: attributedString.length)
        //最大字符 截取位置
        var cutoffLocation = text.length
        
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(Color.fc1), range: textRange)
        
        if let urlRanges : [NSRange] = getRangesByRegex(regex: shorturlRegex, text: text){
            //针对每一个符合网页的NSRange区间
            for range in urlRanges {
                let attchimage : NSTextAttachment = NSTextAttachment()
                
                attchimage.image = UIImage(named: "image")
                attchimage.bounds = CGRect.init(x: 0, y: -4, width: 17, height: 17)
                
                let replaceStr :NSMutableAttributedString = NSMutableAttributedString(attachment: attchimage)
                
                replaceStr.append(NSAttributedString.init(string: "查看图片"))
                
                replaceStr.addAttributes([NSAttributedString.Key.link : "http://img.wxcha.com/file/201811/21/afe8559b5e.gif"], range: NSRange.init(location: 0, length: replaceStr.length))
            
                let newLocation = range.location - (textRange.length - attributedString.length)
                
                //图标+描述 替换HTTP链接字符
                attributedString.replaceCharacters(in: NSRange(location: newLocation, length: range.length), with: replaceStr)
                //如果最多字符个数会截断高亮字符，则舍去高亮字符
                if cutoffLocation >= newLocation && cutoffLocation <= newLocation + range.length {
                    cutoffLocation = newLocation
                }
            }
        }
        
        
        if  let topicRanges:[NSRange] = getRangesByRegex(regex: topicRegex, text: attributedString.string) {
            for range in topicRanges {
            attributedString.addAttributes([NSAttributedString.Key.link :"https://github.com/wsl2ls"], range: range)
                //如果最多字符个数会截断高亮字符，则舍去高亮字符
                if cutoffLocation >= range.location && cutoffLocation <= range.location + range.length {
                    cutoffLocation = range.location
                }
            }
        }
          
        
        
         let style = NSMutableParagraphStyle()
         style.lineSpacing = 4
         let length = attributedString.string.length
        
        attributedString.addAttributes(
            [
             NSAttributedString.Key.font : MFont(style: .Title_17_R).getUIFont(),
             NSAttributedString.Key.paragraphStyle : style
            ],
            
            range: NSRange(location: 0, length: length))
        
        
        
        
        
        let attributedStringHeight = (attributedString, heightOfAttributedString(attributedString))
        return attributedStringHeight
        
    }
    
    
}


//根据匹配规则返回所有的匹配区间
public func getRangesByRegex(regex : String, text: String) -> [NSRange]? {
    do{
        // 正则初始化
        let regex = try NSRegularExpression(pattern:regex, options: [])
        // 字符总长度
        let all = NSRange(location: 0, length: text.count)
        // 匹配
        var ranges : [NSRange] = []
        regex.enumerateMatches(in: text, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: all) { result, _ , _ in
            if let result = result {
                ranges.append(result.range)
            }
        }
        return ranges
    }catch{
        return nil
    }
    
}



//计算富文本的高度
func heightOfAttributedString(_ attributedString: NSAttributedString) -> CGFloat {
    let height : CGFloat =  attributedString.boundingRect(with: CGSize(width: SW, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
    return ceil(height)
}

public func matchRegex(str : String, regex: String) -> [String]?{
    do {
        //初始化正则
        let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        //获得总长度
        let all = NSRange(location: 0, length: str.count)
        //准备结果数组
        var matches : [String] = []
        //在全长范围内正则
        regex.enumerateMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: all) {
            (result : NSTextCheckingResult?, _, _) in
            if let r = result {
                let nsstr = str as NSString
                //按照得到的正则范围切割Str，放入结果数组
                let result = nsstr.substring(with: r.range) as String
                matches.append(result)
            }
        }
        return matches
    } catch {
        return nil
    }
}
