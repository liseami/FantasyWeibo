//
//  PostView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/6.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRaw: View {
 
    
    let post : Post
    let avatarW = SW * 0.14
    
    var body: some View {
        HStack(alignment: .top,  spacing:12){
        
         
          
            UserAvatar(url: URL(string: post.user?.avatar_large ?? ""))
                .canOpenProfile(uid: post.user?.id)
                        
            
            VStack(alignment: .leading,spacing:4){
                
                userline
                
                
                Text(post.text ?? "")
                    .multilineTextAlignment(.leading)
                    .PF_Leading()
                    .mFont(style: .Title_17_R,color: .fc1)
            
                PostPicsView(urls: post.pic_urls.compactMap({ pic_url in
                            getbmiddleImageUrl(urlString: pic_url.thumbnail_pic!)
                }), h: getimageAreaHeight(urlscount: post.pic_urls.count))
                    .ifshow(!post.pic_urls.isEmpty)
                
              
             
                
                btns
              
                
                
            }
        }
        .padding(.all,12)
        .background(Color.Card)
        .onTapGesture {
            PostDataCenter.shared.targetPost = post
            UIState.shared.showPostDetailView = true
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    
    var userline : some View {
        HStack(alignment: .center, spacing:6){
            Text(post.user?.name ?? "用户名不可见")
                .mFont(style: .Title_17_B,color: .fc1)
                .canOpenProfile(uid: post.user?.id)
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
                                Text(btn == .comment ? post.comments_count : btn == .repost ? post.reposts_count : post.attitudes_count)
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
        PostRaw(post: Post.init())
            .previewLayout(.sizeThatFits)
        ZStack{
            Color.BackGround.ignoresSafeArea()
            PostRaw(post: Post.init())
                .padding(.all,12)
        }
 
       
    }
}



struct goProfileBtn : ViewModifier{
    var uid : String?
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
    func canOpenProfile(uid:String?) -> some View{
        self.modifier(goProfileBtn(uid: uid))
    }
}



func getbmiddleImageUrl(urlString:String) -> String {
    var result = ""
//    "http://wx2.sinaimg.cn/"
    let http = urlString.match(#"http://.*\.cn/"#).first?.first
//    "bmiddle/"
//    "008iCELoly1gy31bnhznqg30m80cinpf"
    let imagename = urlString.match(#"\w{32}"#).first?.first
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
    let imagename = urlString.match(#"\w{32}"#).first?.first
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
