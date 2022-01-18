//
//  Message.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI


class InBoxManager : ObservableObject{
    static let shared  = InBoxManager()
    
    @Published var mentionList : [Post] = []
    @Published var commentsMentions : [Comment] = []
    
    enum messageSwitch:MTPageSegmentProtocol {
        case like
        case comment
        case mentions

        var showText: String{
            switch self {
            case .like:
                    return "赞"
            case .comment:
                    return "评论"
            case .mentions:
                    return "@提及我"
            }
        }
    }
    
    @Published var messageTab : messageSwitch = .like
    var tabitems : [messageSwitch] = [.mentions,.comment,.like]
    
    
    func getUserMentions(){
        switch ProjectConfig.env{
        case .test :
            let target =  PostApi.get_user_mentions(p: .init())
            Networking.requestArray(target, modeType: Post.self, atKeyPath: "statuses") { r , arr  in
                if let arr = arr {
                    self.mentionList = arr
                }
            }
        case .mok:
            if let arr = MockTool.readArray(Post.self, fileName: "mentions", atKeyPath: "statuses"){
                self.mentionList = arr
            }
        }
    }
    
    func getuserCommentsMentions(){
        switch ProjectConfig.env{
        case .test :
            let target =  PostApi.get_user_comments_mentions(p: .init( count: 100))
            Networking.requestArray(target, modeType: Comment.self, atKeyPath: "comments") { r , arr  in
                if let arr = arr {
                    self.commentsMentions = arr
                }
            }
        case .mok:
//            if let arr = MockTool.readArray(Post.self, fileName: "mentions", atKeyPath: "statuses"){
//                self.mentionList = arr
//            }
            let target =  PostApi.get_user_comments_mentions(p: .init( count: 100))
            Networking.requestArray(target, modeType: Comment.self, atKeyPath: "comments") { r , arr  in
                if let arr = arr {
                    self.commentsMentions = arr
                }
            }
        }
    }
}


struct InBoxView: View {
    

    
    @ObservedObject var vm = InBoxManager.shared
    @State private var offset : CGFloat = 0
    @State private var pageIndex : Int = 0
    
    @Namespace var tabanimation
    var body: some View {
        
        
         
        ZStack{
            
            Color.BackGround.ignoresSafeArea()
        
            
            VStack(spacing:0){
                MT_PageSegmentView(titles: vm.tabitems, offset: $offset)
                //Text("\(Int(floor(offset + 0.5) / ScreenWidth()))")
                MT_PageScrollowView(offset: $offset) {
                    mainViews
                }
            }
            .frame(width: SW)
            .navigationBarTitleDisplayMode(.inline)
            
           

        }

        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("消息"))
    
    }
    
    @ViewBuilder
    var mainViews : some View {
        HStack(spacing: 0) {
            Group {
                
                //@我
                mentions
                
                ScrollView {
                    LazyVStack(spacing:24){
                        ForEach(vm.commentsMentions,id:\.self.id) { comment in
                            HStack{
                                UserAvatar(url: URL(string: comment.user?.avatar_large ?? ""))
                                VStack{
                                    Text(comment.user?.name ?? "")
                                        .mFont(style: .Body_15_B,color:.fc1)
                                    Text(comment.text ?? "")
                                        .mFont(style: .Body_15_R,color:.fc1)
                                }
                            }
                        }
                    }
                    .padding(.all,24)
                }
                .onAppear {
                    vm.getuserCommentsMentions()
                }
                
                ScrollView {
                    LazyVStack(spacing:24){
                        ForEach(0 ..< 5) { item in
                            message
                        }
                    }
                    .padding(.all,24)
                }
           
            }
            .frame(width: SW)
            .onChange(of: offset) { value in
                self.pageIndex = Int(floor(offset + 0.5) / SW)
            }
        }
    }
    
    var mentions : some View{
        ScrollView {
                LazyVStack(spacing:12){
                    ForEach(vm.mentionList,id:\.self.id) { post  in
                        TweetCard(post: post)
                    }
                }
                .padding(.all,12)
                .onAppear {
                    vm.getUserMentions()
                }
        }
        .background(Color.BackGround.ignoresSafeArea())
    }
    
    var tabbar : some View{
        VStack(spacing:12){
            HStack(spacing:24){
                ForEach(vm.tabitems,id:\.self){item in
                    let selected = item == vm.messageTab
            
                    VStack(alignment: .center, spacing: 8){
                        Text(item.showText)
                        .mFont(style: .Title_17_B,color: selected ? .fc1 : .fc2)
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .frame(maxWidth:44, maxHeight: 3)
                            .foregroundColor(.MainColor)
                            .ifshow(selected)
                            .matchedGeometryEffect(id: "tabanimation", in: tabanimation)
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .frame(maxWidth:44, maxHeight: 3)
                            .foregroundColor(.clear)
                            .ifshow(!selected)
                            
                    }
                    .onTapGesture {
                        withAnimation {
                            vm.messageTab = item
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal,24)
            .padding(.top,24)
            .background(RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .frame(maxHeight: 0.5)
                            .foregroundColor(.fc3.opacity(0.6)),alignment: .bottom)
                
        }
    }
    var message : some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .top,  spacing:12){
                Image("liseamiAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: SW * 0.12, height: SW * 0.12)
                    .clipShape(Circle())
               
                VStack(alignment: .leading, spacing: 6){
                    Text(randomString(3))
                        .mFont(style: .Title_17_B,color: .fc1)
                    
                    Text(randomString(Int.random(in: 0...120)))
                        .mFont(style: .Title_17_R,color: .fc2)
                }
           
                
                Spacer()
            }
            Text("12:21")
                .mFont(style: .Body_13_R,color: .fc3)
        }
           
        
    }
}

struct InBoxView_Previews: PreviewProvider {
    static var previews: some View {
        
//        ContentView(uistate: .init(tabbarIndex: .Message, logged: true))
        InBoxView()
    }
}
