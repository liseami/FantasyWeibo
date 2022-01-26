//
//  PF_TextView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/26.
//

import SwiftUI

struct PF_TextView: View {
    var text : String
    
    
    init(_ text : String = "[拳头]//@爱豆衣帽间:做独立坚强的自己[拳頭]//@你这样子真的很不好耶:好的！#超级小话题# //@芋泥柚柚黑咖啡_:生猛 勇敢 善良 乐观 祝你也祝我 http://t.cn/skdjfasj"){
        self.text = text
    }
    
    var body: some View {
        replex()
    }
    
    
    
    
    // 获取满足条件的集合
    func getRange(str:String,regex:String) -> [NSRange]? {
        do{
            let regex = try NSRegularExpression.init(pattern: regex, options: .caseInsensitive)
            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, NSAttributedString(string: str).length))
            
            var result = [NSRange]()
            for re in res {
                result.append(re.range)
            }
            return result
        }catch{
            return nil
        }
    }
    
    
    func replex() -> some View{
        let userRanges = getRange(str: text, regex: #"@[\u4e00-\u9fa5A-Z0-9a-z_-]{2,30}"#)
        
        let urlRanges = getRange(str: text, regex: #"https{0,1}://t.cn/[A-Z0-9a-z]{6,8}[/]{0,1}"#)
        
        let topicRanges = getRange(str: text, regex: #"#[^@<>#"&'\r\n\t]{1,49}#"#)
        
        
        
        
        var att = AttributedString(text)
        var nsatt = NSAttributedString(att)
        var nsmu = NSMutableAttributedString(attributedString: nsatt)
        
        //@用户
        for range in userRanges!{
            let name = nsmu.attributedSubstring(from: range).string
            let urlstr = "FantasyWeibo://user/\(name)"
            let wapperurl = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            nsmu.addAttribute(NSAttributedString.Key.link, value: URL(string: wapperurl) , range: range)
            nsmu.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(Color.MainColor), range: range)
        }
        
        //#标签#
        for range in topicRanges!{
            let topicname = nsmu.attributedSubstring(from: range).string
            let urlstr = "FantasyWeibo://topic/\(topicname)"
            let wapperurl = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            nsmu.addAttribute(NSAttributedString.Key.link, value: URL(string: wapperurl) , range: range)
            nsmu.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(Color.DeepBlue), range: range)
        }
        
        //url
        for range in urlRanges!{
            let url = nsmu.attributedSubstring(from: range).string
            let urlsheme = "FantasyWeibo://shorturl/\(url)"
            nsmu.addAttribute(NSAttributedString.Key.link, value: URL(string: urlsheme) , range: range)
            nsmu.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor(Color.yellow), range: range)
        }
        
        
        
        nsatt = NSAttributedString(attributedString: nsmu)
        att = AttributedString(nsatt)
        
        return Text(att)
    }
    
    
}

struct PF_TextView_Previews: PreviewProvider {
    static var previews: some View {
        PF_TextView("[拳头]//@爱豆衣帽间:做独立坚强的自己[拳頭]//@你这样子真的很不好耶:好的！//@芋泥柚柚黑咖啡_:生猛 勇敢 善良 乐观 祝你也祝我")
    }
}

//
////正则替换
//func regexPattern(pattern:String,str:String,withTemplate:String) -> String {
//
//    var finalStr = str
//
//    do {
//        // - 1、创建规则
//        let pattern = pattern
//        // - 2、创建正则表达式对象
//        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
//
//        // - 3、正则替换
//        finalStr = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count), withTemplate: withTemplate)
//
//
//
//    }
//    catch {
//        print(error)
//    }
//
//    return finalStr
//}
