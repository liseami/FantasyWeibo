//
//  BSTextView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/17.
//

import SwiftUI
import BSText
import FantasyUI



let teststr = "//@百变小精-0:妮妮是黑龙江哈尔滨人 来家乡报答父老乡亲的//@重生之麻薯座头鲸:我妮闯东北是吧//@爱捅人的小女孩:这场确实牛，宁宁是惊喜嘉宾//@KIM_GDA:[good]"

struct BSTextViewTest : View{
    var body: some View{
        ScrollView {
            
                ForEach(0..<12){ index in
                    
                    Text(teststr)
                        .multilineTextAlignment(.leading)
                        .PF_Leading()
            //            .frame(maxHeight : .infinity)
//                        .mFont(style: .Title_17_R,color: .red)
                        .foregroundColor(.red)
                        .lineSpacing(2)
                        .overlay(BSLabelView(text: teststr))
                        .padding()
                        .background(Color.Card)
                        .PF_Shadow(color: .fc1, style: .s600)
                        .padding()

                }
        }
    }
}

struct BSTextViewTest_PreviewProvider : PreviewProvider{
    static var previews: some View{
        BSTextViewTest()
            .previewLayout(.sizeThatFits)
//        BSTextViewRep()
//            .previewLayout(.sizeThatFits)
    }
}


struct BSLabelView : UIViewRepresentable{
    
    
     var text : String = randomString(44)
    
    func makeUIView(context: Context) -> BSLabel {
        
        let label = BSLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
      
        // 1. Create a text parser
        let simpleEmoticonParser = TextSimpleEmoticonParser()
        var mapper = [String: UIImage]()
        mapper["[good]"] = UIImage.init(named: "WeiboLogo")
        mapper[":cool:"] = UIImage.init(named: "cool.png")
        mapper[":cry:"] = UIImage.init(named: "cry.png")
        mapper[":wink:"] = UIImage.init(named: "wink.png")
        simpleEmoticonParser.emoticonMapper = mapper;

        let markdownParser = TextSimpleMarkdownParser()
        markdownParser.setColorWithDarkTheme()

        label.textParser = simpleEmoticonParser
    
        
        return label
    }
    func updateUIView(_ uiView: BSLabel, context: Context) {
        
//        uiView.text = text
        
        // 1. Create an attributed string.
        let atttext = NSMutableAttributedString(string: text)
            
        // 2. Set attributes to text, you can use almost all CoreText attributes.
//        atttext.bs_font = MFont(style: .Title_17_R).getUIFont()
        atttext.bs_color = UIColor(Color.fc1)
        atttext.bs_font = .systemFont(ofSize: 17)
//        atttext.bs_set(color: UIColor.red, range: NSRange(location: 0, length: 4))
        atttext.bs_lineSpacing = 0
        atttext.bs_alignment = .left
        atttext.bs_lineBreakMode = .byWordWrapping
        
     
        
        uiView.attributedText = atttext
        
    }
}

struct BSTextViewRep : UIViewRepresentable{
    
    let text : String = "//@百变小精-0:妮妮是黑龙江哈尔滨人 来家乡报答父老乡亲的//@重生之麻薯座头鲸:我妮闯东北是吧//@爱捅人的小女孩:这场确实牛，宁宁是惊喜嘉宾//@KIM_GDA:[good]"
    
    func makeUIView(context: Context) -> BSTextView {
        
        let textView = BSTextView()
        
        textView.frame = .infinite
        textView.text = text
        

        
        
        return textView
    }
    func updateUIView(_ uiView: BSTextView, context: Context) {
        
    }
}





