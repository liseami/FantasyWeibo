//
//  PostDetailView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import FantasyUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    
    @State private var offset : CGFloat = 0
    let avatarW = SW * 0.14
    @ObservedObject var vm = PostDataCenter.shared
    @State private var comment : String = ""
    @State private var showPostDetailView : Bool = false
    
    //渲染属性
    let post : Post
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
    var comments_count : String = ""
    var reposts_count : String = ""
    var attitudes_count : String = ""
    
    //评论
    
    @State private var comments : [Comment] = []
    
    
    
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
                        
                        
                        toolbar
                        
                        ForEach(self.comments,id:\.self.id){comment in
                            
                            HStack(alignment: .top, spacing: 12) {
                                UserAvatar(url: URL(string: comment.user?.avatar_large ?? ""))
                                VStack(spacing:6){
                                    HStack{
                                        Text(comment.user?.name ?? "")
                                            .mFont(style: .Body_15_B,color: .fc1)
                                            Spacer()
                                    }
                                  
                                    Text(comment.text ?? "")
                                        .PF_Leading()
                                        .mFont(style: .Title_16_R,color: .fc1)
                                    
                                    Text(stringDateToDate(datestr: comment.created_at!, dateFormat: "EE MMM d hh:mm:ss Z yyyy").toString(dateFormat: "MMM d hh:mm"))
                                        .PF_Leading()
                                        .mFont(style: .Body_12_R,color: .fc2)
                                }
                            }
                        }
                        
                        
                        Spacer()
                    }
                    .padding(.all,16)
                    
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
        .PF_Navilink(isPresented: $showPostDetailView) {
            PostDetailView(post: convertPost(post:post.retweeted_status ?? repostPost.init()))
        }
        
        .onAppear {
            vm.getComments(postid: self.post.id ?? 0) { comments in
                if let comments = comments {
                    self.comments = comments
                }
            }
        }
    }
    
    
    var commentBar : some View {
        
        HStack{
            UserAvatar(url: URL(string: UserManager.shared.locAvatarUrl),frame: GoldenH)
            TextField("添加评论...", text: $comment)
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
    
    var toolbar : some View {
        HStack(spacing:20){
            ForEach(vm.posttoolbtns,id :\.self){ tool in
                HStack(spacing:6){
                    Text(tool == .comment ? comments_count : tool == .repost ? reposts_count : attitudes_count)
                        .mFont(style: .Title_17_B,color: .fc1)
                    Text(tool.title)
                        .mFont(style: .Body_15_R,color: .fc2)
                }
            }
            Spacer()
        }
    }
    var retweetView : some View {
        HStack(alignment:.top,spacing:12) {
            UserAvatar(url: forwarded_user_avatarImageUrl,frame:SW * 0.1)
            VStack(spacing:12){
                HStack(alignment: .center, spacing: 6){
                    Text(forwarded_user_name)
                        .mFont(style: .Title_17_B, color:.fc1)
                    ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                        .padding(.leading,4)
                        .ifshow(self.forwarded_user_isV)
                    Spacer()
                }
                
                PF_TapTextArea(text: forwarded_text,font: MFont(style: .Title_17_R).getUIFont()) {username in
                    
                } taptopic: {topicname in
                    
                } tapshorturl: {shorturl in
                    
                }
                
                TweetMediaView(urls: pic_urls)
            }
            .padding(.top,6)
            
        }
        .padding(.all,12)
        .background(Color.Card)
        .overlay(RoundedRectangle(cornerRadius: 20, style:.continuous )
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.fc1.opacity(0.1))
        )
        .onTapGesture(perform: {
            showPostDetailView.toggle()
        })
        .ifshow(style == .repost)
    }
    
    var mediaArea : some View {
        TweetMediaView(urls: post.pic_urls.compactMap({ pic_url  in
            getbmiddleImageUrl(urlString: pic_url.thumbnail_pic!)
        }))
            .ifshow(!post.pic_urls.isEmpty)
            .ifshow(style != .repost)
    }
    var maincontent : some View {
        
        PF_TapTextArea(text: text,font: MFont(style: .LargeTitle_22_R).getUIFont()) {username in
        } taptopic: {topicname in
            
        } tapshorturl: {shorturl in
            
        }
        
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
            UserAvatar(url: style == .repost_fast ? forwarded_user_avatarImageUrl : avatarImageUrl)
            
            VStack(alignment: .leading, spacing:0){
                HStack(alignment: .center, spacing: 6){
                    Text(style == .repost_fast ? forwarded_user_name : username)
                        .mFont(style: .Body_15_B,color: .fc1)
                    ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                        .padding(.leading,4)
                        .ifshow(style == .repost_fast ? self.forwarded_user_isV : user_isV)
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
                somepost.retweeted_status?.user?.name == "来一杯冰阔乐吗"
            })!
            post = convertPost(post: post.retweeted_status!)
            
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


func stringDateToDate(datestr : String,dateFormat: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = dateFormat
    let date = dateFormatter.date(from:datestr) ?? Date()
    return date
}
