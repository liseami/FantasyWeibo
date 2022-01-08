//
//  ProFileView.swift
//  Fantline
//
//  Created by 赵翔宇 on 2021/12/29.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProFileView: View {
    
    @State private var backcolor : Color = .BackGround
    @State private var offset : CGFloat = 0
    
    var body: some View {
        
        
        ZStack
        {
            Color.BackGround.ignoresSafeArea()
            
            
            if backcolor != .BackGround{
                LinearGradient(gradient: Gradient(colors: [backcolor, backcolor.opacity(0)]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                    .animation(.spring(), value: backcolor)
                    .transition(.move(edge: .top))
            }
           
            BlurView().ignoresSafeArea()
      

            
            PF_OffsetScrollView(offset: $offset) {
            
                VStack(spacing:32){
               
                    VStack(spacing:12){
                        avatar
                        
                        Text("Over Liseami")
                            .mFont(style: .LargeTitle_22_B,color: .fc1)
                        Text("修改资料")
                            .mFont(style: .Body_15_B,color: .fc1)
                            .padding(.horizontal,32)
                            .padding(.vertical,6)
                            .background(Color.fc3.opacity(0.2))
                            .clipShape(Capsule(style: .continuous))
                    }
                  
                    
                    
                    HStack(spacing:SW * 0.12){
                        
                        VStack{
                            Text("249")
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("照片")
                        }
                        
                        VStack{
                            Text("234")
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("推文")
                        }
                        
                        VStack{
                            Text("100102")
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("粉丝")
                        }
                        
                        VStack{
                            Text("429")
                                .mFont(style: .Body_13_B,color: .fc1)
                            Text("关注")
                        }
                       
                    }
                    .mFont(style: .Body_15_R,color: .fc2)

                    
                        Spacer()
                }
                .padding(.all,24)
            }
        
                
                
            }
        .navigationBarTitleDisplayMode(.inline)
            
            
        }
    
    @ViewBuilder
    var avatar : some View {
        let imageurl = URL(string: "https://m.media-amazon.com/images/M/MV5BMjIyNjk1OTgzNV5BMl5BanBnXkFtZTcwOTU0OTk1Mw@@._V1_Ratio1.5000_AL_.jpg")
        if #available(iOS 15.0, *) {
            AsyncImage(url: imageurl){ image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: SW * 0.3,height: SW * 0.3)
                    .clipShape(Circle())
                    .onAppear {
                        let uiimage = image.asUIImage()
                        getDominantColorsByUIImage(uiimage) { color  in
                            DispatchQueue.main.async {
                                madasoft()
                                withAnimation {
                                    self.backcolor = color
                                }
                            }
                        }
                    }
            }placeholder: {
                Color.Card
                    .frame(width: SW * 0.3,height: SW * 0.3)
                    .clipShape(Circle())
                    .overlay(ProgressView())
            }
             
        } else {
            
            WebImage(url: imageurl)
                .resizable()
                .placeholder(content: {
                    Color.Card
                        .frame(width: SW * 0.3,height: SW * 0.3)
                        .clipShape(Circle())
                        .overlay(ProgressView())
                })
                .scaledToFill()
                .frame(width: SW * 0.3,height: SW * 0.3)
                .clipShape(Circle())
                .onAppear {
                    let uiimage =  WebImage(url: imageurl).asUIImage()
                    getDominantColorsByUIImage(uiimage) { color  in
                        DispatchQueue.main.async {
                            madasoft()
                            withAnimation {
                                self.backcolor = color
                            }
                        }
                    }
                }
            
                
        }
        
    }
   
        
    
}

struct ProFileView_Previews: PreviewProvider {
    static var previews: some View {
        ProFileView()
    }
}
