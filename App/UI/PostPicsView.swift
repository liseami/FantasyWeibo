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
        .frame(height :CGFloat(urls.count == 1 ? uistate.postImageAreaWidth * 1.4 : uistate.postImageAreaWidth * 0.618))
        
    }
    
    func reportHToUistate(w:CGFloat){
        guard uistate.postImageAreaWidth == 0 else {return}
        uistate.postImageAreaWidth = Float(w)
    }
}

struct PostPicsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let pic1 = ["http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic2 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic3 = ["http://wx3.sinaimg.cn/large/008iCELoly1gy31bt7g67g30m80cix6v.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic4 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic9 = ["http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        PostPicsView(urls: pic1)
    }
}
