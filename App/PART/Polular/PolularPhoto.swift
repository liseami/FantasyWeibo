//
//  PolularUser.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI

struct PolularPhoto: View {
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false) {
            let w = SW / 3
            let columns =
            Array(repeating:GridItem(.fixed(w), spacing: 0.5), count: 3)
            
                     LazyVGrid(columns: columns, spacing: 6) {
                         ForEach(0..<8) { index in
                             
                             VStack(spacing:6){
                                 Image("\(index + 1)")
                                     .resizable()
                                     .scaledToFill()
                                     .frame(width: w, height: w)
                                     .clipped()
                                 
                                 HStack{
                                     ICON(sysname: "seal.fill",fcolor: index < 3 ? .Purple : .MainColor,size: 20)
                                         .overlay(Text("\(index + 1)")
                                                    .mFont(style: .Body_12_B,color: .Card))
                                     Text(randomString(5))
                                         .mFont(style: .Body_12_B,color: .fc2)
                                 }
                             }
                         }
                     }
                     .frame(width: SW)
        }
     
        
        
    }
}

struct PolularUser_Previews: PreviewProvider {
    static var previews: some View {
        PolularPhoto()
    }
}


struct ColSpan<Content: View>: View {
    let span: Bool
    let content: () -> Content
    
    init(span: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.span = span
        self.content = content
    }
    
    var body: some View {
        content()
        if span { Color.clear }
    }
}

