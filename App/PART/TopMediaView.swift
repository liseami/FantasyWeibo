//
//  TopMediaView.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopMediaView : View{
    
    
    @ObservedObject var uistate = UIState.shared
    @State private var topMediaBackColor : Color = .gray.opacity(0.6)
    @State private var received : Int = 0
    @State private var total : Int = 1
    @GestureState var offset : CGFloat = 0
    @State private var show : Bool = true
    
    
    var body: some View{
        
        
        ZStack{
            topMediaBackColor.ignoresSafeArea()
                .opacity(Double(1 - Float((offset/SW))))
                .transition(.opacity)
                .onTapGesture {
                    withAnimation(.spring()){
                        uistate.showTopMediaArea = false
                    }
                }
            
        
            
            
            
            TabView {
                ForEach(uistate.topImageUrl,id : \.self) {url in
                    
                
                    
                    WebImage(url: URL(string: url))
                        .resizable()
                        .onSuccess { uiimage , data , type  in
                            getDominantColorsByUIImage(uiimage) { color  in
                                withAnimation(.spring()){
                                    self.topMediaBackColor = color
                                }
                            }
                            print(data.debugDescription)
                        }
                        .placeholder(content: {
                            ProgressView()
                        })
    //                        .indicator(.activity(style: .medium))
                        .scaledToFit()
                        .frame(width: SW)
                        .animation(.spring())
                        .offset(y:offset)
                        .onAppear {
                            let url = url.subString(from: 12)
                            Networking.request(ShortUrlApi.getshorturl(p: url )) { result in
                                print(result.rawReponse)
                                print(result.rawData)
                                print(result.dataJson )
                            }
                        }
//                        .overlay(Text(url).mFont(style: .LargeTitle_22_B,color: .red))
                }
            }
            .gesture(getgesture())
            .tabViewStyle(.page(indexDisplayMode: .always))
            
        }
        .ifshow(uistate.showTopMediaArea, animation: .spring(), transition: .move(edge: .bottom))
    }
    
    
    //下拉关闭页面的手势
    func getgesture() -> some Gesture {
        return  DragGesture(minimumDistance: 12, coordinateSpace: .global)
            .updating($offset) { value, out, transition in
                let height = value.translation.height
                out = height
            }
            .onEnded { value in
                let height = value.translation.height
                if height > SW * 0.3 {
                    uistate.showTopMediaArea = false
                }
            }
    }
}


struct TopMediaView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        TopMediaView(uistate: UIState.init(topMediaUrl: ["https://photo.weibo.com/h5/comment/compic_id/1022:2305976568fe7403655ed611b72446c150f308"], showTopMediaArea: true))
        
        
        
    }
}



