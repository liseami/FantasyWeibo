//
//  PostPicsView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import SwiftUI
import SDWebImageSwiftUI
import FantasyUI

struct TweetPicView: View {
    
    let urls : [String]
    @ObservedObject var uistate = UIState.shared
    var cliped : Bool = true
    
    var body: some View {
        
        if cliped {
            geometryReader
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }else{
            geometryReader
        }
      
        
    }
    
    var geometryReader : some View {
        
        GeometryReader { geometryproxy in
            
            let w = geometryproxy.frame(in: .global).width
            let h = geometryproxy.frame(in: .global).height
            
            Color.clear
                .frame(width: w)
            //上报尺寸
                .onAppear(perform: {
                    uistate.picAreaW = w
                })
                .overlay(
                    Group{
                        switch urls.count{
                        case 1 :
                            WebImage(url: URL(string: urls[0]))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        case 2 :
                            
                            HStack(spacing:1){
                                WebImage(url: URL(string: urls[0]))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 2)
                                    .clipped()
                                WebImage(url: URL(string: urls[1]))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 2)
                                    .clipped()
                            }
                            
                        case 3 :
                            
                            HStack(spacing:1){
                                WebImage(url: URL(string: urls[0]))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 2)
                                    .clipped()
                                VStack(spacing:1){
                                    WebImage(url: URL(string: urls[1]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: h / 2)
                                        .clipped()
                                    WebImage(url: URL(string: urls[2]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: h / 2)
                                        .clipped()
                                }
                                .frame(width: w / 2)
                                .clipped()
                            }
                            .clipped()
                            
                        case 4 :
                            let columns =
                            Array(repeating:GridItem(.fixed(w / 2), spacing: 1), count: 2)
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                                ForEach(urls,id:\.self){url in
                                    WebImage(url: URL(string: url))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: h / 2)
                                        .clipped()
                                }
                            }
                            
                            
                        case 5 :
                            
                            VStack(spacing:1){
                            HStack(spacing:1){
                                WebImage(url: URL(string: urls.first!))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 3)
                                    .clipped()
                                WebImage(url: URL(string: urls[1]))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 3)
                                    .clipped()
                                WebImage(url: URL(string: urls[2]))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: w / 3)
                                    .clipped()
                            }
                            .frame(height : w / 3)
                            .clipped()
                                
                                HStack(spacing:1){
                                    WebImage(url: URL(string: urls[3]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: w / 2)
                                        .clipped()
                                    WebImage(url: URL(string: urls[4]))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: w / 2)
                                        .clipped()
                                }
                                
                            .frame(height : w / 3)
                            .clipped()
                            }
                            
                        case 6...999 :
                            
                            let columns =
                            Array(repeating:GridItem(.fixed(w / 3), spacing: 1), count: 3)
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
                                ForEach(urls,id:\.self){ url in
                                    WebImage(url: URL(string: url))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: w / 3, height: w / 3)
                                        .clipped()
                                }
                            }
                            
                            
                        default:
                            EmptyView()
                        }
                    }
                   
                    
                )
                .clipped()
        }
        .frame(height : getImageAreaH())
    }
    func getImageAreaH()->CGFloat {
        let w = uistate.picAreaW
        let goldenW =  w * 0.618
        switch urls.count {
        case 1 : return w * 1.4
        case 2...4 : return goldenW
        case 4...6 : return (w / 3) * 2
        case 7...9 : return w
        case 10...12 : return (w / 3) * 4
        case 13...999 : return (w / 3)  * 5
        default : return 0
        }
    }
    
    
    
}

struct PostPicsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let pic1 = ["http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic2 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic3 = ["http://wx3.sinaimg.cn/large/008iCELoly1gy31bt7g67g30m80cix6v.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        let pic4 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/thumbnail/008iZYDvly1gy4ui9sizsj30u01mcwlj.jpg"]
        let pic5 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif"]
        let pic6 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif"]
        let pic7 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif"]
        let pic8 = ["http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/thumbnail/008iZYDvly1gy4ui9sizsj30u01mcwlj.jpg","http://wx2.sinaimg.cn/large/008iCELoly1gy31bpm0n2g30m80ci1l6.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg","http://wx2.sinaimg.cn/thumbnail/008iZYDvly1gy4ui9sizsj30u01mcwlj.jpg","http://wx2.sinaimg.cn/thumbnail/008iZYDvly1gy4ui9sizsj30u01mcwlj.jpg"]
        let pic9 = ["http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx3.sinaimg.cn/large/008iCELoly1gy31br5vb9g30m80ci4qv.gif","http://wx2.sinaimg.cn/large/008iCELoly1gy31bnhznqg30m80cinpf.gif","http://wx3.sinaimg.cn/large/008iCELoly1gxhv8efkp0j30h10mvwgi.jpg"]
        
        TweetPicView(urls: pic1)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic2)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic3)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic4)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic5)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic6)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic7)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic8)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetPicView(urls: pic9)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        
        
        
    }
}
