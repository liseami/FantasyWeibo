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
    var avatarImageUrl : URL? = nil
    var username : String = ""
    var repost_user_name : String = ""
    var text : String = ""
    var pic_urls : [String] = []
    var comments_count : String = ""
    var reposts_count : String = ""
    var attitudes_count : String = ""
    var repost_user_avatarImageUrl : URL? = nil
    var repost_text : String = ""
    
    
    
    enum styleEnum {
        case post
        case repost_wihtouttext
        case repost_wihttext
    }
    
    
    init(post:Post){
        self.post = post
        tweetdata_init(post: post)
    }
    
  
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:12){
            ///转发人用户名 + 转发推文
            retweet_userline
            
            HStack(alignment: .top,  spacing:12){
                ///头像
                UserAvatar(url:self.avatarImageUrl)
                    .canOpenProfile(uid: post.user?.id  ?? "")
                
                ///推文内容
                tweet_content
            }
        }
        .padding(.all,8)
        .padding(.vertical,6)
        .background(Color.Card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        
    }
    
    
    
    var tweet_content : some View{
        
        VStack(alignment: .leading,spacing:4){
            
            userline
            
            Text(self.text)
                .multilineTextAlignment(.leading)
                .PF_Leading()
                .mFont(style: .Title_17_R,color: .fc1)
        
            PostPicsView(urls: self.pic_urls, h: getimageAreaHeight(urlscount: post.pic_urls.count))
                .ifshow(!pic_urls.isEmpty)
            

            btns
          
            
            
        }
    }
    var retweet_userline : some View {
        HStack{
            Text(repost_user_name + " 转发微博")
            ICON(name:"enter",fcolor: .fc1,size: 16)
        }
            .mFont(style: .Body_15_B,color: .fc1)
            .padding(.horizontal,12)
            .padding(.vertical,4)
            .background(Color.fc1.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .PF_Leading()
            .ifshow(style == .repost_wihtouttext)
    }
    @ViewBuilder
    var userline : some View {
        
        HStack(alignment: .center, spacing:6){
            Text(self.username)
                .mFont(style: .Title_17_B,color: .fc1)
                .canOpenProfile(uid: post.user?.id ?? "")
//            Text("@" + (post.user?.id ?? ""))
//                .mFont(style: .Title_17_R,color: .fc2)
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
        TweetCard(post: Post.init())
            .previewLayout(.sizeThatFits)
        ZStack{
            Color.BackGround.ignoresSafeArea()
            ContentView()
        }
 
    }
}

extension TweetCard {
    mutating func tweetdata_init(post:Post){
        if let repost = post.retweeted_status{
            if repost.text == "" || post.text == "转发微博"{
                //快转微博
                self.style = .repost_wihtouttext
                self.text = repost.text
                if !repost.pic_urls.isEmpty{
                    self.pic_urls = repost.pic_urls.map({ postpicurl in
                        getbmiddleImageUrl(urlString: postpicurl.thumbnail_pic!)
                    })
                }
                self.comments_count = repost.comments_count ?? ""
                self.reposts_count = repost.reposts_count ?? ""
                self.attitudes_count = repost.attitudes_count ?? ""
                self.avatarImageUrl = URL(string: repost.user?.avatar_large ?? "")
                self.repost_user_name = post.user?.name ?? ""
                self.username = repost.user?.name ?? ""
                
            }else{
                //带文字转发微博
                self.style = .repost_wihttext
                //主体
                self.text = post.text ?? ""
                self.avatarImageUrl = URL(string: post.user?.avatar_large ?? "")
                self.username = post.user?.name ?? ""
                
                self.comments_count = post.comments_count
                self.reposts_count = post.reposts_count
                self.attitudes_count = post.attitudes_count
                //被转发的post
                self.repost_user_name = repost.user?.name ?? ""
                self.repost_user_avatarImageUrl = URL(string: repost.user?.avatar_large ?? "")
                self.repost_text = repost.text
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



struct goProfileBtn : ViewModifier{
    var uid : String
    func body(content: Content) -> some View {
        Button {
            UserManager.shared.getProfileData(uid: uid)
            PostDataCenter.shared.getProFileTimeLine()
            UIState.shared.showProfileView = true
        } label: {
            content
        }
    }
}

extension View{
    func canOpenProfile(uid:String) -> some View{
        self.modifier(goProfileBtn(uid: uid))
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


func getimageAreaHeight(urlscount : Int) -> CGFloat{
    let w = UIState.shared.showPostDetailView ? UIState.shared.postImageAreaWidth_Detail : UIState.shared.postImageAreaWidth_HomeView
    let h = CGFloat(urlscount == 1 ? w * 1.4 : w * 0.618)
    return h
}
