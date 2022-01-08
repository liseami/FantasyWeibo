//
//  SearchView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI

struct SearchView: View {
 
    @State private var startToSearch : Bool = false
    @State private var offset : CGFloat = 0
    @ObservedObject var vm = SearchManager.shared
    
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset) {
            
            VStack(spacing:24){
                
                
                hotSearchContent
                
                hotUser
                
                hotPost
                
                Spacer()
                
            }
            .padding(.vertical,24)
           
           
          
        }
        .PF_Navitop(style: self.offset < -6 ? .large : .none, backgroundView: {
            BlurView()
        }, TopCenterView: {
        })
        .navigationBarTitleDisplayMode(.inline)
        .PF_Navilink(isPresented: $vm.showSearchInputView) {
            SearchInputView()
        }
        .background(Color.Card.ignoresSafeArea())

    }
    
    var hotPost : some View{
        VStack{
            HStack{
                Text("附近推文")
                    .mFont(style: .Title_19_B,color: .fc1)
                Text("附近的用户")
                    .mFont(style: .Title_19_B,color: .fc3)
                Spacer()
                Text("过滤")
                    .mFont(style: .Body_15_B,color: .MainColor)
            }
            .padding(.horizontal,24)
            
                VStack(spacing:12){
                    ForEach(0..<12){index in
                       PostRaw(username: randomString(3), usernickname: randomString(4), postcontent: randomString(140))
                    }
                }
                .padding(.horizontal,8)
              
        }
        
    }
    
    
    var hotUser : some View{
        VStack{
            HStack{
                Text("热门搜索账号")
                    .mFont(style: .Title_19_B,color: .fc1)
                Spacer()
                Text("显示全部")
                    .mFont(style: .Body_15_B,color: .MainColor)
            }
            .padding(.horizontal,24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:12){
                    Spacer().frame(width: 12)
                    ForEach(0..<12){index in
                        hotUserCard(username: randomString(6))
                    }
                }
              
            }
        }
    
    }
    var hotSearchContent : some View {
        VStack{
            Text("推圈搜索趋势")
                .mFont(style: .Title_19_B,color: .fc1)
                .PF_Leading()
            
            let w = SW / 2
            let columns =
            Array(repeating:GridItem(.adaptive(minimum: w, maximum: w), spacing: 0), count: 2)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                
                ForEach(0..<6){index in
                    HStack(spacing:12){
                        Text(randomString(6))
                            .mFont(style: .Title_17_R,color: .fc2)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal,24)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(uistate: UIState.init(tabbarIndex: .Search))
    }
}


struct hotUserCard : View{
    let username : String
    var body: some View{
        VStack(spacing:4){
            Image("liseamiAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: SW * 0.16, height: SW * 0.16)
                .clipShape(Circle())
            Text(username)
                .mFont(style: .Body_15_B,color: .fc1)
            Text("热门")
                .mFont(style: .Body_13_R,color: .fc3)
         
            Spacer().frame(width: 0, height: 16)
            
            Text("关注")
                .mFont(style: .Body_15_B,color: .white)
                .frame(maxWidth:SW * 0.24)
                .padding(.vertical,2)
                .background(Color.MainColor)
                .cornerRadius(4)
            
        }
        .padding(.all,16)
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(lineWidth: 0.5, antialiased: false).foregroundColor(.back1))
    }
}
