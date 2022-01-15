//
//  ViewMod.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/15.
//

import SwiftUI

struct TextTag : ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding(.horizontal,12)
            .padding(.vertical,6)
            .background(Color.back1)
            .clipShape(Capsule(style: .continuous))
    }
}

extension View{
    func textTag() -> some View {
        self.modifier(TextTag())
    }
}
