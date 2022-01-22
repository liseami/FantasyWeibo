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
    
    enum messageSwitch {
        //        case like
        case comment
        case mentions
        
        var title: String{
            switch self {
                //            case .like:
                //                    return "赞"
            case .comment:
                return "评论"
            case .mentions:
                return "@提及我"
            }
        }
    }
    
    @Published var messageTab : messageSwitch = .mentions
    
    var tabitems : [messageSwitch] = [.mentions,.comment]
    
    
    //@我
    func getUserMentions(){
        DispatchQueue.global().async {
            switch ProjectConfig.env{
            case .test :
                let target =  PostApi.get_user_mentions(p: .init())
                Networking.requestArray(target, modeType: Post.self, atKeyPath: "statuses") { r , arr  in
                    if let arr = arr {
                        DispatchQueue.main.async {
                            self.mentionList = arr
                        }
                        
                    }
                }
            case .mok:
                if let arr = MockTool.readArray(Post.self, fileName: "mentions", atKeyPath: "statuses"){
                    DispatchQueue.main.async {
                        self.mentionList = arr
                    }
                }
            }
        }
        
    }
    
    
    //@我的评论
    func getuserCommentsMentions(){
        
        DispatchQueue.global().async {
            switch ProjectConfig.env{
            case .test :
                let target =  PostApi.get_user_comments_mentions(p: .init( count: 100))
                Networking.requestArray(target, modeType: Comment.self, atKeyPath: "comments") { r , arr  in
                    if let arr = arr {
                        DispatchQueue.main.async {
                            self.commentsMentions = arr
                        }
                    }
                }
            case .mok:
                if let arr = MockTool.readArray(Comment.self, fileName: "commentsmentions", atKeyPath: "comments"){
                    DispatchQueue.main.async {
                    self.commentsMentions = arr
                    }
                }
                
            }
        }
        
    }
}


struct InBoxView: View {
    
    
    
    @ObservedObject var vm = InBoxManager.shared
    @State private var offset : CGFloat = 0
    @Namespace var tabanimation
    
    var body: some View {
        
        
        
        ZStack{
            
            Color.BackGround.ignoresSafeArea()
            
            
            VStack(spacing:0){
                
                tabbar
                
                TabView(selection: $vm.messageTab) {
                    mentions.tag(InBoxManager.messageSwitch.mentions)
                    commentsmentions.tag(InBoxManager.messageSwitch.comment)
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }
            .frame(width: SW)
            
            
            
            
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
                
                
                
            }
            .frame(width: SW)
        }
    }
    
    var mentions : some View{
        ScrollView {
            LazyVStack(spacing:12){
                ForEach(vm.mentionList,id:\.self.id) { post  in
//                    TweetCard(post: post)
                }
            }
            .padding(.all,12)
            .onAppear {
                guard vm.mentionList.isEmpty else {return}
                vm.getUserMentions()
            }
        }
        .background(Color.BackGround.ignoresSafeArea())
    }
    
    var commentsmentions : some View {
        ScrollView {
            LazyVStack(spacing:0){
                ForEach(vm.commentsMentions,id:\.self.id) { comment in
                    HStack(spacing:12){
                        UserAvatar(url: URL(string: comment.user?.avatar_large ?? ""))
                        VStack(alignment: .leading, spacing: 4){
                            Text(comment.user?.name ?? "")
                                .PF_Leading()
                                .mFont(style: .Title_17_B,color:.fc1)
                            PF_TapTextArea(text: comment.text ?? "", font: MFont(style: .Title_17_R).returnUIFont()) { username in
                                
                            } taptopic: { topicname in
                                
                            } tapimage: { shorturl in
                                
                            }
                        }
                    }
                    .padding(.horizontal,12)
                    .padding(.vertical,12)
                    .overlay(Line(),alignment: .bottom)
                    
                }
            }
            .padding(.vertical,12)
        }
        .onAppear {
            guard vm.commentsMentions.isEmpty else {return}
            vm.getuserCommentsMentions()
        }
    }
    
    var tabbar : some View{
        HStack{
            
            ForEach(vm.tabitems,id:\.self) { item in
                Color.BackGround
                    .frame(height: GoldenH)
                    .overlay( Text(item.title).mFont(style: .Title_17_B,color:.fc1))
                    .onTapGesture {
                        withAnimation(.spring()){
                            vm.messageTab = item
                        }
                    }
                    .overlay(
                        Capsule(style: .continuous)
                            .frame( height: 3.5)
                            .foregroundColor(.MainColor)
                            .padding(.horizontal,12)
                            .animation(.spring(), value: vm.messageTab)
                            .matchedGeometryEffect(id: "tabitem", in: tabanimation)
                            .ifshow(item.title == vm.messageTab.title)
                        
                        ,alignment:.bottom)
                
            }
        }
        .overlay(Line(),alignment: .bottom)
    }
    //私信
    //    var message : some View {
    //        HStack(alignment: .center, spacing: 0) {
    //            HStack(alignment: .top,  spacing:12){
    //                Image("liseamiAvatar")
    //                    .resizable()
    //                    .scaledToFill()
    //                    .frame(width: SW * 0.12, height: SW * 0.12)
    //                    .clipShape(Circle())
    //                VStack(alignment: .leading, spacing: 6){
    //                    Text(randomString(3))
    //                        .mFont(style: .Title_17_B,color: .fc1)
    //
    //                    Text(randomString(Int.random(in: 0...120)))
    //                        .mFont(style: .Title_17_R,color: .fc2)
    //                }
    //                Spacer()
    //            }
    //            Text("12:21")
    //                .mFont(style: .Body_13_R,color: .fc3)
    //        }
    //    }
}

struct InBoxView_Previews: PreviewProvider {
    static var previews: some View {
        
        // ContentView(uistate: .init(tabbarIndex: .Message, logged: true))
        InBoxView()
    }
}
