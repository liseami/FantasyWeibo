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
            let h = geometryproxy.frame(in: .global).height
            let imagew = (w - 1) / 2
            let imageh = (h - 1) / 2
            
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
                                    .frame(width: imagew)
                                WebImage(url: URL(string: urls.last! )!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imagew)
                            }
                            case 3 : HStack(spacing:1){
                                WebImage(url: URL(string: urls.first! )!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imagew)
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1] )!)
                                        .resizable()
                                        .scaledToFill()
                                         .frame(width: imagew,height: imageh,alignment:.center)
                                        .clipped()
                                    WebImage(url: URL(string: urls.last! )!)
                                        .resizable()
                                        .scaledToFill()
                                         .frame(width: imagew,height: imageh,alignment:.center)
                                        .clipped()
                                }
                            }
                            case 4...9999 : HStack(spacing:1){
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls.first! )!)
                                        .resizable()
                                        .scaledToFill()
                                         .frame(width: imagew,height: imageh,alignment:.center)
                                        .clipped()
                                    WebImage(url: URL(string: urls[2] )!)
                                        .resizable()
                                        .scaledToFill()
                                         .frame(width: imagew,height: imageh,alignment:.center)
                                        .clipped()
                                }
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1] )!)
                                        .resizable()
                                        .scaledToFill()
                                         .frame(width: imagew,height: imageh,alignment:.center)
                                         .clipped()
                                    WebImage(url: URL(string: urls[3] )!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imagew,height: imageh,alignment:.center)
                                        .clipped()
                                }
                            }
                            default:
                                EmptyView()
                            }
                        }
                       
                    )
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .frame(height :CGFloat(urls.count == 1 ? uistate.imageGroup_Height_V : uistate.imageGroup_Height_H))
        
    }
    
    func reportHToUistate(w:CGFloat){
        guard uistate.imageGroup_Height_H == 0 else {return}
        let vh = w * 1.4
        let hh = w * 0.618
        uistate.imageGroup_Height_V = Float(vh)
        uistate.imageGroup_Height_H = Float(hh)
        
    }
}

struct PostPicsView_Previews: PreviewProvider {
    static var previews: some View {
        PostPicsView(urls: Array(repeating: "http://wx3.sinaimg.cn/large/006Cr5dqly1gyb8iuoaarj30jg0jin0l.jpg",count: 3))
    }
}
