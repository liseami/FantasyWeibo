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
        
        GeometryReader { geo  in
            ActiveLabelTest(str: "This is a post witThis is a post witThis is a post with #hashtags and a @userhandle. @userhandle.",width: geo.size.width)
        }
    
        
    }
}



struct Testtt_Previews: PreviewProvider {
    static var previews: some View {
        Testtt()
    }
}



struct ActiveLabelTest : UIViewRepresentable {
    
    var str : String
    var width: CGFloat
    
    func makeUIView(context: Context) -> UILabel {
        
        let label = ActiveLabel()
        label.enabledTypes = [.mention, .hashtag, .url]
        label.text = str
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.preferredMaxLayoutWidth = width
        label.handleHashtagTap { hashtag in
                    print("Success. You just tapped the \(hashtag) hashtag")
                }
        label.autoresizingMask = .flexibleHeight
        return label
    }
    func updateUIView(_ uiView: UILabel, context: Context) {
        
    }
}

