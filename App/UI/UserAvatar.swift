//
//  UserAvatar.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserAvatar: View {
    let url : URL?
    var frame : CGFloat = SW * 0.14
    
    var body: some View {
        
            WebImage(url: url)
                .resizable()
                .placeholder(content: {
                    Color.back1
                })
                .scaledToFill()
                .frame(width: frame, height: frame)
                .clipShape(Circle())

    }
}

struct UserAvatar_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatar(url: nil)
    }
}
