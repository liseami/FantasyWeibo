//
//  PostDetailView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import FantasyUI
import SDWebImageSwiftUI


class PostDetailViewModel : ObservableObject {
    
    @Published var mainCommentsList : [Comment] = []
    @Published var subcomments : [Comment] = []
    @Published var isloadingcomments : Bool = false
    @Published var targetUser : User = User.init()
    @Published var showPostDetailView : Bool = false
    @Published var showProfileView : Bool = false
    
    func getcommentslist(_ postid : Int) {
        
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                self.isloadingcomments = true
            }
            
            switch ProjectConfig.env{
            case .test :
                let target = PostApi.get_post_comments(p: .init( id: postid, since_id: 0, max_id: 0, count: 100, page: 1, filter_by_author: 0))
                Networking.requestArray(target, modeType: Comment.self, atKeyPath: "comments") { r, comments  in
                    
                    if let comments = comments {
                        for comment in comments {
                            //没有 reply_comment 字段的，加入maincomment
                            DispatchQueue.main.async {
                                if comment.reply_comment == nil{
                                    self.mainCommentsList.append(comment)
                                }else{
                                    self.subcomments.append(comment)
                                }
                            }
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.isloadingcomments = false
                    }
                    
                }
                
            case .mok:
                
                if let comments = MockTool.readArray(Comment.self, fileName: "comments", atKeyPath: "comments"){
                    
                    for comment in comments {
                        //没有 reply_comment 字段的，加入maincomment
                        DispatchQueue.main.async {
                            if comment.reply_comment == nil{
                                self.mainCommentsList.append(comment)
                            }else{
                                self.subcomments.append(comment)
                            }
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.isloadingcomments = false
                    }
                    
                }
                
            }
            
        }
    }
}


struct PostDetailView: View {
    
    @StateObject var vm  = PostDetailViewModel()
    
    //UI
    @State private var offset : CGFloat = 0
    
    
    //类型
    var style : styleEnum = .post
    
    //主体
    var avatarImageUrl : URL? = nil
    var username : String = ""
    var text : String = ""
    var pic_urls : [String] = []
    var user_isV : Bool = false
    
    var forwarded_user_isV : Bool = false
    var forwarded_user_name : String = ""
    var forwarded_text : String = ""
    var forwarded_user_avatarImageUrl : URL? = nil
    
    //数据
    let post : Post
    var comments_count : String = ""
    var reposts_count : String = ""
    var attitudes_count : String = ""
    
    //评论
    @State private var comments : [Comment] = []
    //添加评论
    @State private var commentInput : String = ""
    
    
    
    
    
    //类型
    enum styleEnum {
        case post
        case repost
        case repost_fast
    }
    
    //初始化
    init(post:Post){
        self.post = post
        tweet_detail_init(post: post)
    }
    
    
    var body: some View {
        
        ZStack{
            
            
            PF_OffsetScrollView(offset: $offset) {
                Group{
                    
                    VStack(alignment: .leading, spacing:24){
                        
                        Group{
                            //快转人
                            retweet_userline
                                .ifshow(style == .repost_fast)
                            
                            topUserInfoLine
                            
                            //文字
                            maincontent
                            
                            //图片视频
                            mediaArea
                            
                            //被转发微博
                            retweetView
                            
                            //数据栏
                            databar
                            
                            //工具栏
                            toolbtns
                            
                        }
                        .padding(.horizontal,16)
                        
                        Line()
                        
                        //评论列表
                        commentslist
                        
                        Spacer()
                    }
                }
            }
            
            //评论输入框
            commentBar
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text("详情"))
        .PF_Navitop(style:offset < -5 ? .large : .none) {
            BlurView()
        } TopCenterView: {
            EmptyView()
        }
        .PF_Navilink(isPresented: $vm.showPostDetailView) {
            PostDetailView(post: convertPost(post:post.retweeted_status ?? repostPost.init()))
        }
        .PF_Navilink(isPresented: $vm.showProfileView, content: {
            ProFileView(vm.targetUser)
        })
        //        进入页面时，获取页面评论
        .onAppear {
            ///防止重复获取
            print("获取评论列表🐒")
            guard vm.mainCommentsList.isEmpty && !vm.isloadingcomments else {return}
            vm.getcommentslist(self.post.id)
            
        }
    }
    
    
    @ViewBuilder
    var commentslist : some View{
        
        
        if vm.isloadingcomments {
            ProgressView()
                .frame(maxWidth:.infinity,alignment: .center)
        }else{
            if !vm.mainCommentsList.isEmpty {
                let comments = vm.mainCommentsList
                LazyVStack(spacing:0){
                    ForEach(comments,id:\.self.id){comment in
                        CommentView(comment: comment, subcomments: findsubcomments(maincommentid: comment.id))
                            .environmentObject(vm)
                    }
                }
                
            }else{
                TextPlaceHolder(text: "", subline: "暂无评论",style: .inline)
                    .frame(maxWidth:.infinity,alignment: .center)
            }
        }
    }
    //寻找主评论的副评论
    func findsubcomments(maincommentid : Int)-> [Comment]{
        var subcomments = [Comment]()
        for comment in vm.subcomments {
            if comment.reply_comment?.id == maincommentid{
                subcomments.append(comment)
            }
        }
        return subcomments
    }
    
    var commentBar : some View {
        
        HStack{
            UserAvatar(url: URL(string: UserManager.shared.locAvatarUrl),frame: GoldenH)
            TextField("添加评论...", text: $commentInput)
                .mFont(style: .Body_15_R,color: .fc1)
                .multilineTextAlignment(.leading)
                .padding(.horizontal,12)
                .frame( height: GoldenH)
                .overlay(Capsule(style: .continuous).stroke(lineWidth: 0.5).foregroundColor(.fc3.opacity(0.3)))
        }
        .padding(.all,12)
        .overlay(Line(),alignment: .top)
        .background(Color.Card.ignoresSafeArea())
        .MoveTo(.bottomCenter)
        
    }
    
    var databar : some View {
        VStack(spacing:12){
            Line()
            HStack(spacing:20){
                ForEach(PostDataCenter.shared.posttoolbtns,id :\.self){ tool in
                    HStack(spacing:6){
                        Text(tool == .comment ? comments_count : tool == .repost ? reposts_count : attitudes_count)
                            .mFont(style: .Title_17_B,color: .fc1)
                        Text(tool.title)
                            .mFont(style: .Body_15_R,color: .fc2)
                    }
                }
                Spacer()
            }
            Line()
        }
    }
    
    var toolbtns : some View {
        HStack{
            ForEach(PostDataCenter.shared.posttoolbtns,id :\.self){ tool in
                ICON(name: tool.iconname,fcolor:.fc2,size:20)
                    .frame(maxWidth:.infinity)
            }
        }
        
    }
    
    
    var retweetView : some View {
        VStack(alignment:.leading,spacing:12) {
            
            VStack(alignment:.leading,spacing:12){
                Button {
                    vm.targetUser = post.retweeted_status!.user!
                    vm.showProfileView = true
                } label: {
                    HStack(alignment: .center, spacing: 6){
                        UserAvatar(url: forwarded_user_avatarImageUrl,frame:SW * 0.06)
                        Text(forwarded_user_name)
                            .mFont(style: .Title_17_B, color:.fc1)
                        ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                            .padding(.leading,4)
                            .ifshow(self.forwarded_user_isV)
                        Spacer()
                    }
                }
                
//                PF_MakeTextArea(text: text)
                PF_TextArea(text: text, font: MFont(style: .Title_16_R).returnUIFont())
                
                
            }
            .padding(.all,12)
            
            TweetMediaView(urls: pic_urls,cliped: false, width: SW - 32 - 24)
                .ifshow(!pic_urls.isEmpty)
        }
        .background(Color.Card)
        .overlay(RoundedRectangle(cornerRadius: 20, style:.continuous )
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.fc1.opacity(0.1))
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style:.continuous ))
        .onTapGesture(perform: {
            vm.showPostDetailView.toggle()
        })
        .ifshow(style == .repost)
    }
    
    var mediaArea : some View {
        TweetMediaView(urls: post.pic_urls.compactMap({ pic_url  in
            getbmiddleImageUrl(urlString: pic_url.thumbnail_pic!)
        }), width: SW - 32)
            .ifshow(!post.pic_urls.isEmpty)
            .ifshow(style != .repost)
    }
    var maincontent : some View {
        
        PF_TextArea(text: text, font:MFont(style: .LargeTitle_22_R).returnUIFont())
        
        
    }
    var retweet_userline : some View {
        HStack{
            UserAvatar(url: forwarded_user_avatarImageUrl,frame: SW * 0.08)
            Text(forwarded_user_name + " 转发微博")
            ICON(name:"enter",fcolor: .fc1,size: 16)
        }
        .mFont(style: .Body_15_B,color: .fc1)
        .padding(.all,6)
        .padding(.trailing,6)
        .background(Color.back1)
        .clipShape(Capsule(style: .continuous))
        .PF_Leading()
    }
    
    @ViewBuilder
    var topUserInfoLine : some View {
        
        HStack(alignment: .center,  spacing:12){
            Button {
                
                if style == .repost_fast{
                    vm.targetUser = post.retweeted_status!.user!
                }else{
                    vm.targetUser = post.user!
                }
                vm.showProfileView = true
                
            } label: {
                UserAvatar(url: style == .repost_fast ? forwarded_user_avatarImageUrl : avatarImageUrl)
            }
            
            
            
            VStack(alignment: .leading, spacing:0){
                
                Button {
                    
                    if style == .repost_fast{
                        vm.targetUser = post.retweeted_status!.user!
                    }else{
                        vm.targetUser = post.user!
                    }
                    vm.showProfileView = true
                    
                } label: {
                    HStack(alignment: .center, spacing: 6){
                        Text(style == .repost_fast ? forwarded_user_name : username)
                            .mFont(style: .Body_15_B,color: .fc1)
                        ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                            .padding(.leading,4)
                            .ifshow(style == .repost_fast ? self.forwarded_user_isV : user_isV)
                    }
                }
                
                Text(getUserInfoSubLine())
                    .lineLimit(2)
                    .mFont(style: .Body_15_R,color: .fc2)
            }
            Spacer()
        }
        
    }
    
    func getUserInfoSubLine() -> String{
        
        switch style {
        case .post,.repost:
            if let description = post.user?.description{
                return description
            }
            if let location =  post.user?.location{
                return location
            }
            return "/"
        case .repost_fast:
            if let description = post.retweeted_status?.user?.description{
                return description
            }
            if let location =  post.retweeted_status?.user?.location{
                return location
            }
            return "/"
        }
    }
    
}

struct PostDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        var post = Post()
        if let posts = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
            post = posts.first(where: { somepost in
                somepost.user?.name == "黑历史打脸bot"
            })!
            
            //            post = convertPost(post: post.retweeted_status!)
            
        }
        return  NavigationView {
            Text("")
                .PF_Navilink(isPresented: .constant(true)) {
                    PostDetailView( post: post)
                }
        }
    }
}






extension PostDetailView{
    mutating func tweet_detail_init(post:Post){
        if let repost = post.retweeted_status{
            if repost.text == "" || post.text == "转发微博"{
                //快转微博
                self.style = .repost_fast
                
                self.username = post.user?.name ?? ""
                
                self.text = repost.text
                if !repost.pic_urls.isEmpty{
                    self.pic_urls = repost.pic_urls.map({ postpicurl in
                        getbmiddleImageUrl(urlString: postpicurl.thumbnail_pic!)
                    })
                }
                self.forwarded_user_avatarImageUrl = URL(string: repost.user?.avatar_large ?? "")
                self.forwarded_user_name = repost.user?.name ?? ""
                self.forwarded_user_isV = repost.user?.verified ?? false
                
                self.comments_count = repost.comments_count ?? ""
                self.reposts_count = repost.reposts_count ?? ""
                self.attitudes_count = repost.attitudes_count ?? ""
                
            }else{
                //带文字转发微博
                self.style = .repost
                //主体
                self.text = post.text ?? ""
                self.avatarImageUrl = URL(string: post.user?.avatar_large ?? "")
                self.username = post.user?.name ?? ""
                self.user_isV = post.user?.verified ?? false
                
                self.comments_count = post.comments_count
                self.reposts_count = post.reposts_count
                self.attitudes_count = post.attitudes_count
                
                //被转发的post
                self.forwarded_user_isV = repost.user?.verified ?? false
                self.forwarded_user_name = repost.user?.name ?? ""
                self.forwarded_user_avatarImageUrl = URL(string: repost.user?.avatar_large ?? "")
                self.forwarded_text = repost.text
                if !repost.pic_urls.isEmpty{
                    self.pic_urls = repost.pic_urls.map({ postpicurl in
                        getbmiddleImageUrl(urlString: postpicurl.thumbnail_pic!)
                    })
                }
            }
        }else{
            //原创微博
            self.style = .post
            self.avatarImageUrl = URL(string: post.user?.avatar_large ?? "")
            self.username = post.user?.name ?? ""
            self.user_isV = post.user?.verified ?? false
            self.text = post.text ?? ""
            if !post.pic_urls.isEmpty{
                self.pic_urls = post.pic_urls.map({ postpicurl in
                    getbmiddleImageUrl(urlString: postpicurl.thumbnail_pic!)
                })
            }
            
            self.comments_count = post.comments_count
            self.reposts_count = post.reposts_count
            self.attitudes_count = post.attitudes_count
        }
    }
}



struct CommentView : View {
    @EnvironmentObject var vm : PostDetailViewModel
    
    let comment : Comment
    let subcomments : [Comment]?
    
    
    var body : some View{
        
        if let subcomments = self.subcomments{
            VStack{
                self.makecommentLine(user:comment.user!, text: comment.text!)
                ForEach(subcomments,id: \.self.id){comment in
                    self.makecommentLine(user:comment.user!,text: comment.text!)
                }
            }
            .background(Rectangle().fill(Color.back1).frame(width: 2).padding(.leading,SW * 0.07).padding(.vertical,12 + 4 + (SW * 0.14) ).ifshow(!subcomments.isEmpty),alignment: .leading)
            .padding(.horizontal,16)
            .overlay(Line(),alignment:.bottom)
        }else{
            EmptyView()
        }
        
        
        
    }
    
    func makecommentLine(user:User,text:String) -> some View{
        return  HStack(alignment: .top, spacing: 12) {
            
            Button {
                vm.targetUser = user
                vm.showProfileView = true
            } label: {
                UserAvatar(url: URL(string: user.avatar_large ?? ""),frame: SW * 0.14)
            }
            
            
            
            VStack(spacing:2){
                HStack{
                    Button {
                        vm.targetUser = user
                        vm.showProfileView = true
                    } label: {
                        Text(user.name ?? "")
                            .mFont(style: .Body_15_B,color: .fc1)
                    }
                    Spacer()
                }
                
                PF_TextArea(text: text, font: MFont(style: .Title_16_R).returnUIFont())
            }
        }
        .padding(.vertical,12)
        
    }
}
