//
//  Polular.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI




class PolularViewModule : ObservableObject{
    static let shared  = PolularViewModule()
    
    
 
    
   
}


struct PolularView: View {
    
    @State private var offset : CGFloat = 0
    @State private var pageIndex : Int = 0
    @ObservedObject var vm = PolularViewModule.shared
    
    var body: some View {
        

        VStack(spacing:0){
         
        }
        .frame(width: SW)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("Web3"))
    }

    
    
    @ViewBuilder
    var mainViews : some View {
        HStack(spacing: 0) {
            Group {
                PolularPhoto()
                PolularVideo()
                PolularPost()
                PolularSpace()
            }
            .frame(width: SW)
            .onChange(of: offset) { value in
                self.pageIndex = Int(floor(offset + 0.5) / SW)
            }
        }
    }
}

struct PolularView_Previews: PreviewProvider {
    static var previews: some View {
        PolularView()
    }
}



