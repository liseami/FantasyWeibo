//
//  PostPicsView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostPicsView: View {
    let urls : [String]
    
    
    @ObservedObject var uistate = UIState.shared
    
    
    var body: some View {
        GeometryReader { geometryproxy in
          
            let w = geometryproxy.frame(in: .global).width
            
            Color.clear
                    .frame(width: w)
                    .onAppear(perform: {
                        reportHToUistate(w: w)
                    })
                    .overlay(
                        Group{
                            switch urls.count{
                            case 1 :
                                
                                WebImage(url: URL(string: urls.first!)!)
                                    .resizable()
                                    .scaledToFill()
                                
                            case 2 : HStack(spacing:1){
                                WebImage(url: URL(string: urls.first! )!)
                                    .resizable()
                                    .scaledToFill()
                                WebImage(url: URL(string: urls.last! )!)
                                    .resizable()
                                    .scaledToFill()
                            }
                            case 3 : HStack(spacing:1){
                                WebImage(url: URL(string: urls.first! )!)
                                    .resizable()
                                    .scaledToFill()
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1] )!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls.last! )!)
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            case 4...9999 : HStack(spacing:1){
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls.first! )!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls[2] )!)
                                        .resizable()
                                        .scaledToFill()
                                }
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1] )!)
                                        .resizable()
                                        .scaledToFill()
                                    WebImage(url: URL(string: urls[3] )!)
                                        .resizable()
                                        .scaledToFill()
                                }
                            }
                            default:
                                EmptyView()
                            }
                        }
                       
                    )
                    .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .frame(height :CGFloat(uistate.imageGroup_Height))
        
    }
    
    func reportHToUistate(w:CGFloat){
        guard uistate.imageGroup_Height == 0 else {return}
        let h = w * (urls.count == 1 ? 1.4 : 0.618)
        uistate.imageGroup_Height = Float(h)
    }
}

struct PostPicsView_Previews: PreviewProvider {
    static var previews: some View {
        PostPicsView(urls: Array(repeating: "http://wx3.sinaimg.cn/large/006Cr5dqly1gyb8iuoaarj30jg0jin0l.jpg",count: 3))
    }
}
