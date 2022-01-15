//
//  PostView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import SDWebImageSwiftUI


struct TweetCard: View {
    
    let post : Post
    var avatarW = SW * 0.14
    var style : styleEnum = .post
    
    var user_isV : Bool = false
    var username : String = ""
    var avatarImageUrl : URL? = nil
    var text : String = ""

    var forwarded_user_isV : Bool = false
    var forwarded_user_name : String = ""
    var forwarded_user_avatarImageUrl : URL? = nil
    var forwarded_text : String = ""

    var pic_urls : [String] = []
    
    var comments_count : String = ""
    var reposts_count : String = ""
    var attitudes_count : String = ""
    
    @State private var showPostDeatilView : Bool = false
    @State private var showProfileView : Bool = false
    
    @State private var targetPost : Post?
    
    enum styleEnum {
        case post
        case repost_fast
        case repost
    }
    
    init(post:Post){
        self.post = post
        self.targetPost = post
        tweetdata_init(post: post)
    }
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:12){
                ///转发人用户名 + 转发推文
                retweet_userline
            HStack(alignment: .top,  spacing:12){
                ///头像
                mainAvatar
                ///推文内容
                VStack(alignment: .leading,spacing:4){
                    //主要用户信息
                    mainUserLine
                    //主要文字
                    mainText
                    //主要图片
                    mainPics
                    //被转发微博
                    forwarded_post
                    //按钮 + 数据
                    btns
                }
            }
        }
        .padding(.all,8)
        .padding(.vertical,6)
        .background(Color.Card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture(perform: {
           
            targetPost = style == .repost_fast ? convertPost(post: post.retweeted_status ?? repostPost.init()) : post
            showPostDeatilView.toggle()
        })
        .PF_Navilink(isPresented: $showProfileView) {
            ProFileView()
        }
        .PF_Navilink(isPresented: $showPostDeatilView) {
            PostDetailView(post : self.targetPost ?? Post.init())
        }
        
    }
    
    var mainText : some View {
        Text(self.text)
            .multilineTextAlignment(.leading)
            .PF_Leading()
            .mFont(style: .Title_17_R,color: .fc1)
    }
    
    var mainAvatar : some View {
        Button {
            showProfileView.toggle()
        } label: {
            UserAvatar(url: style == .repost_fast ? forwarded_user_avatarImageUrl : avatarImageUrl)
        }
    }
    
    var mainPics : some View{
        TweetPicView(urls: self.pic_urls)
            .ifshow(!pic_urls.isEmpty)
            .ifshow(style != .repost)
            .padding(.top,8)
    }
    
    var forwarded_post : some View{
        ///被正常转发的微博
        VStack(spacing:0){
            VStack(alignment: .leading, spacing:12){
                HStack(spacing:6){
                    UserAvatar(url: forwarded_user_avatarImageUrl,frame:SW * 0.06)
                    Text(forwarded_user_name)
                        .mFont(style: .Title_17_B,color: .fc1)
                    ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                        .padding(.leading,4)
                        .ifshow(self.forwarded_user_isV)
                    Spacer()
                }
                
                Text(forwarded_text)
                    .frame(maxHeight:.infinity)
                    .mFont(style: .Title_17_R,color: .fc1)
                  
            }
            .padding(.all,12)
            
            TweetPicView(urls: pic_urls,cliped: false)
            
        }
        .background(Color.Card)
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1).foregroundColor(.fc3.opacity(0.6)))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .ifshow(style == .repost)
        .onTapGesture(perform: {
            //点击卡片中被转发的微博，进入被转发的微博详情
            self.targetPost = convertPost(post: post.retweeted_status!)
            showPostDeatilView.toggle()
        })
        .padding(.top,8)
    
    }
    
    var retweet_userline : some View {
        HStack{
            Text(username + " 转发微博")
            ICON(name:"enter",fcolor: .fc1,size: 16)
        }
        .mFont(style: .Body_15_B,color: .fc1)
        .padding(.horizontal,12)
        .padding(.vertical,4)
        .background(Color.fc1.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .PF_Leading()
        .ifshow(style == .repost_fast)
    }
    
    @ViewBuilder
    var mainUserLine : some View {
        
        HStack(alignment: .center, spacing:6){
            Text(style != .repost_fast ? username : forwarded_user_name)
                .mFont(style: .Title_17_B,color: .fc1)
            ICON(sysname: "checkmark.seal.fill",fcolor: .MainColor,size: 16)
                .padding(.leading,4)
                .ifshow(style == .post ? self.user_isV : self.forwarded_user_isV)
            
            
            //   Text("@" + (post.user?.id ?? ""))
            //   .mFont(style: .Title_17_R,color: .fc2)
            Spacer()
            
            Menu {
                PF_MenuBtn(text: "关注", name: "Like") {
                }
            } label: {
                ICON(sysname: "ellipsis",fcolor: .fc3,size: 16)
                    .disabled(true)
                    .padding(.trailing,6)
                    .background(Color.Card)
            }
        }
    }
    
    @ViewBuilder
    var btns : some View{
        HStack(spacing:12){
            ForEach(PostDataCenter.shared.posttoolbtns,id :\.self){ btn in
                Spacer()
                    .frame( height: 16)
                    .overlay(
                        Button(action: {
                            madasoft()
                        }, label: {
                            HStack(spacing:8){
                                ICON(name: btn.iconname,fcolor:.fc2,size: 16)
                                
                                Text(btn == .comment ? comments_count : btn == .repost ? reposts_count : attitudes_count)
                            }
                        })
                        ,alignment: .leading)
            }
        }
        .mFont(style: .Body_13_R,color: .fc2)
        .padding(.trailing,SW * 0.1)
        .padding(.top,12)
    }
}

struct PostRaw_Previews: PreviewProvider {
    static var previews: some View {
        
        var post = Post()
        if let posts = MockTool.readArray(Post.self, fileName: "timelinedata", atKeyPath: "statuses"){
            post = posts.first(where: { somepost in
                somepost.retweeted_status?.user?.name == "BOBO口口"
            })!
        }
        
       return  TweetCard(post: post)
               .previewLayout(.sizeThatFits)
//        ZStack{
//            Color.BackGround.ignoresSafeArea()
//            ContentView()
//        }
        
    }
}

extension TweetCard {
    mutating func tweetdata_init(post:Post){
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





func getbmiddleImageUrl(urlString:String) -> String {
    var result = ""
    //    "http://wx2.sinaimg.cn/"
    let http = urlString.match(#"http://.*\.cn/"#).first?.first
    //    "bmiddle/"
    //    "008iCELoly1gy31bnhznqg30m80cinpf"
    let imagename = urlString.match(#"\w{20,40}"#).first?.first
    let fileformat = urlString.match(#"\.jpg|\.png|\.gif|\.jpeg"#).first?.first
    result = http! + "bmiddle/" + imagename! + fileformat!
    return result
}

func getblargeImageUrl(urlString:String) -> String {
    var result = ""
    //    "http://wx2.sinaimg.cn/"
    let http = urlString.match(#"http://.*\.cn/"#).first?.first
    //    "bmiddle/"
    //    "008iCELoly1gy31bnhznqg30m80cinpf"
    let imagename = urlString.match(#"\w{20,40}"#).first?.first
    let fileformat = urlString.match(#"\.jpg|\.png|\.gif|\.jpeg"#).first?.first
    result = http! + "large/" + imagename! + fileformat!
    return result
}


extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, nsString.length)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}



 func convertPost(post: repostPost) -> Post{
    
    let result = Post.init(created_at: post.created_at, id: post.id, idstr: post.idstr, mid: post.mid, can_edit: post.can_edit, show_additional_indication: post.show_additional_indication, text: post.text, textLength: post.textLength, source_allowclick: post.source_allowclick, source_type: post.source_type, source: post.source, favorited: post.favorited, truncated: post.truncated, in_reply_to_status_id: post.in_reply_to_status_id, in_reply_to_user_id: post.in_reply_to_user_id, in_reply_to_screen_name: post.in_reply_to_screen_name, pic_urls: post.pic_urls, bmiddle_pic: nil, original_pic: nil, geo: nil, is_paid: post.is_paid, mblog_vip_type: post.mblog_vip_type, user: post.user, retweeted_status: nil, picStatus: nil, reposts_count: post.reposts_count ?? "", comments_count: post.comments_count ?? "", reprint_cmt_count: post.reprint_cmt_count ?? "", attitudes_count: post.attitudes_count ?? "", pending_approval_count: post.pending_approval_count, isLongText: post.isLongText, reward_exhibition_type: post.reward_exhibition_type, hide_flag: post.hide_flag, mlevel: post.mlevel, biz_feature: post.biz_feature, hasActionTypeCard: post.hasActionTypeCard, positive_recom_flag: post.positive_recom_flag, enable_comment_guide: false, content_auth: post.content_auth, gif_ids: post.gif_ids, is_show_bulletin: post.is_show_bulletin, pic_num: post.pic_num ?? 0, reprint_type: post.reprint_type, can_reprint: post.can_reprint, new_comment_style: post.new_comment_style)
    
    return result
    
}
