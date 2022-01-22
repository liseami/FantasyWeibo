//
//  SearchInputView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI





struct SearchInputView: View {
    
    @ObservedObject var vm = SearchManager.shared
    
    @State private var offset : CGFloat = 0
    @State private var pageIndex : Int = 0
    
    @State private var searchContext : String = ""
    @State private var firstResponder : Bool = true
    
    var body: some View {
        

        VStack{
            
            HStack{
                PF_TextField(text: $searchContext, isFirstResponder: $firstResponder){
                    $0.textAlignment = .left
                    $0.textColor = UIColor(Color.fc1)
                    $0.font = UIFont.systemFont(ofSize: 17)
                    $0.placeholder = "搜索新浪微博"
                }
                .padding(.all,12)
                .frame(height: 32)
                .background(Color.back1)
                .clipShape(Capsule(style: .continuous))
                Spacer()
               
                Button("取消"){
                    vm.showSearchInputView.toggle()
                }
                .mFont(style: .Title_17_B,color: .fc2)
            }
            .padding(.horizontal,12)
            
            VStack(spacing:0){
            
            }
            .frame(width: SW)

            
          
            
        }
        .navigationBarHidden(true)
        
        
            
    }
    
    @ViewBuilder
    var mainViews : some View {
        HStack(spacing: 0) {
            Group {
               Text("最热")
                Text("最新")
                Text("人物")
                Text("照片")
                Text("视频")
                Text("Space")
            }
            .frame(width: SW)
            .onChange(of: offset) { value in
                self.pageIndex = Int(floor(offset + 0.5) / SW)
            }
        }
    }
    
}

struct SearchInputView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInputView()
    }
}
