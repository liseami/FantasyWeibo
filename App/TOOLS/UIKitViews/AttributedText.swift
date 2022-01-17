//
//  AttributedText.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/16.
//


import SwiftUI
import UIKit
import AttributedString
import SDWebImageSwiftUI
import FantasyUI

struct AttributedTextView: View {
    var body: some View {
       
                AttributedText(fixedWidth: SW * 0.8)
                    .overlay(Color.red.opacity(0.3))
                    .scaledToFit()
                
            
    
    }
}



struct AttributedTextView_Previews: PreviewProvider {
    static var previews: some View {
        AttributedTextView()
    }
}



struct AttributedText : UIViewRepresentable {
    
    var text : String =  "//@当时我就震惊了:耳朵怀孕了[泪]//@我有一个超酷的微博名：这个翻译也很绝//@派大星inside:卧槽，好听！//@搭令哒：爱乐之城的感觉//@晕尼格格鹿：和音好棒！"
    var font : UIFont = MFont(style: .Title_17_R).getUIFont()
    
    let textView =  UITextView(frame: .zero)
    var fixedWidth: CGFloat
    
    func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }
    
    class Coordinator: NSObject, UITextViewDelegate {
           var parent: AttributedText
           init(_ parent: AttributedText) {
               self.parent = parent
           }
       }
    
    
    
    
    
    func clickedUser(){
        madasoft()
    }
    func makeUIView(context: Context) -> UITextView {
        
        guard textView.text.isEmpty else {return UITextView()}
        let regexweibousers = #"@[\u4e00-\u9fa5A-Z0-9a-z_-]{2,30}"#
        let regexweibotexts = ":[^/]*"
        //用户名
        let users : [String] = text.regex(regex: regexweibousers) ?? []
        
        //开头的
        let slash : ASAttributedString = .init(string: "//",.font(self.font),.foreground(UIColor(Color.fc1)))
        
        //如果存在转发文案
        if users.isEmpty {
            textView.attributed.text += .init(string: self.text,.font(self.font))
        }
        else{
            textView.attributed.text += slash
            for i in 0...(users.count - 1) {
                let username = users[i]
                let user : ASAttributedString = .init(string: username,.font(self.font),.foreground(UIColor(Color.MainColor)),.action(clickedUser))
                var usertext = text.regex(regex: (username + regexweibotexts))!.first ?? ""
                if usertext.count - username.count > 0 {
                    usertext = String(usertext.suffix(usertext.count - username.count))
                }
                let user_text : ASAttributedString = .init(string: usertext,.font(self.font),.foreground(UIColor(Color.fc1)))
                
                textView.attributed.text  += (user + user_text)
                if i != (users.count - 1){
                    textView.attributed.text  += slash
                }
            }
        }
        
              textView.isEditable = false
              textView.isScrollEnabled = false
              textView.backgroundColor = UIColor(named: "Card") // just to make it easier to see
              textView.delegate = context.coordinator
              textView.translatesAutoresizingMaskIntoConstraints = false
              textView.widthAnchor.constraint(equalToConstant: fixedWidth).isActive = true //<--- Here
              
        
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async { //<--- Here
                 
             }
    }

}

