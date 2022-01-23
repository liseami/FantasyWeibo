//
//  PostPicsView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import SwiftUI
import FantasyUI
import AVKit
import SDWebImageSwiftUI


class VideoPlayerVM : ObservableObject{
    
    var player = AVPlayer()
    func play(url:URL){
        self.player = AVPlayer(url: url)
        player.allowsExternalPlayback = true
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
        player.play()
    }
    
}



struct TweetMediaView: View {
    
    let urls : [String]
    let width : CGFloat
    var cliped : Bool = true
    @State private var player : AVPlayer = AVPlayer()
    
    @ObservedObject var uistate = UIState.shared
    
    init(urls : [String],cliped : Bool = true,width : CGFloat ) {
        self.width = width
        self.urls = urls
        self.cliped = cliped
        if urls.count == 1 {
            if urls.first!.count < 30 {
                if let url = URL(string: urls.first!){
                    self.player = AVPlayer(url:url)
                }
            }
        }
    }
    
    var body: some View {
        
        
        Group{
            if cliped {
                mainview
                    .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }else{
                mainview
            }
        }
        .clipped()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @ViewBuilder
    var mainview : some View {
        
        GeometryReader{geo in
            let w = geo.size.width
            let h = geo.size.height
            Group{
                switch urls.count{
                case 1 :
                    let url = urls.first!
                    switch url.count {
                    case 31...999 :
                         WebImage(url: URL(string: urls[0]))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    case 0...30 :
                        VideoPlayer(player: AVPlayer())
                        
                    default :
                        EmptyView()
                    }
                    
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
        }
        .frame(width: width, height: getImageAreaH())
        
    }
    
    
    func getImageAreaH()->CGFloat {
        let w = width
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
        
        TweetMediaView(urls: pic1, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic2, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic3, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic4, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic5, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic6, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic7, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic8, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        TweetMediaView(urls: pic9, width: SW)
            .previewLayout(.fixed(width: SW,height: SW * 2))
        
        
        
    }
}

