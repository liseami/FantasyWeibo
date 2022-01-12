//
//  TimeLineView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/5.
//

import SwiftUI
import FantasyUI

struct TimeLineView: View {
    @State private var offset : CGFloat = 0
    @ObservedObject var uistate = UIState.shared
    @ObservedObject var vm = TimeLineViewModel.shared
    
    let str = randomString(Int.random(in: 12...140))
    
    var body: some View {
        
        
        PF_OffsetScrollView(offset: $offset, content: {
            
            
            LazyVStack {
                Spacer().frame(width: 1, height: 1)
                
                if !vm.posts.isEmpty {
                    ForEach(vm.posts,id:\.self.id){ post in
                        PostRaw(post: post)
                    }
                }else{
                    placeHolder
                }
                
                Spacer().frame(width: 1, height: 80)
            }
            .padding(.all,12)
            
            
        })
            .navigationBarTitleDisplayMode(.inline)
            .PF_Navitop(style:offset < -5 ? .large : .none) {
                BlurView()
            } TopCenterView: {
                Image("Web3Logo")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .scaledToFit()
            }
            .onAppear {
                vm.getTimeLine()
                madasoft()
            }
        
    }
    
    var placeHolder : some View {
        VStack{
            Spacer()
            TextPlaceHolder(text: "暂无数据", subline: "请尝试刷新数据。",style: .inline)
            MainButton(title: "刷新") {
                vm.getTimeLine()
            }
            Spacer()
            .padding(.horizontal,32)
            Spacer()
        }
        .padding(.horizontal,32)
        
        
    }
    
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(uistate: UIState.init(tabbarIndex: .Timeline, logged: true))
    }
}


class TimeLineViewModel : ObservableObject{
    static let shared = TimeLineViewModel()
    
    @Published var timelinedata : TimeLineResponse?
    @Published var posts : [TimeLinePost] = []
    
    
    func getTimeLine() {
        let target = TimeLineApi.get(p: .init())
        //        Networking.requestObject(target, modeType: TimeLineResponse.self) { r, m in
        //            print(m)
        //            if let m = m {
        //                self.timelinedata = m
        //            }
        //        }
        Networking.requestArray(target, modeType: TimeLinePost.self, atKeyPath: "statuses") { r, arr in
            if let arr = arr {
                self.posts = arr
            }
            
        }
    }
}


enum TimeLineApi : ApiType{
    
    case get(p:getTimeLineReqMod)
    
    var path: String {
        return "statuses/home_timeline.json"
    }
    
    var method: HTTPMethod{
        .get
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .get(let p):
            return p.kj.JSONObject()
        }
    }
    //
    //    var parameterEncoding: ParameterEncoding{
    //        return JSONEncoding.default
    //    }
    
}


struct getTimeLineReqMod : Convertible{
    
    var access_token : String?    /// 采用OAuth授权方式为必填参数，OAuth授权后获得。
    var since_id     : Int?       ///若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    var max_id       : Int?       ///若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    var count        : Int?       ///单页返回的记录条数，最大不超过100，默认为20。
    var page         : Int?       ///返回结果的页码，默认为1。
    var base_app     : Int?       ///是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    var feature      : Int?      /// 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    var trim_user    : Int?     /// 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
    
}



struct User : Convertible{
    var  id: String?
    var  screen_name: String?
    var  name: String?
    var  province: String?
    var  city: String?
    var  location: String?
    var  description: String?
    var  url: String?
    var  profile_image_url: String?
    var  domain: String?
    var  gender: String?
    var  followers_count: String?
    var  friends_count: String?
    var  statuses_count: String?
    var  favourites_count: String?
    var  created_at: String?
    var  following: Bool = false
    var  allow_all_act_msg: Bool = false
    var  remark: String?
    var  geo_enabled: Bool = false
    var  verified: Bool = false
    var  allow_all_comment: Bool = false
    var  avatar_large: String?
    var  verified_reason: String?
    var  follow_me: Bool = false
    var  online_status: String?
    var  bi_followers_count: String?
}


struct Weibo_ADPost : Convertible{
    var id : String?
    var mark : String?
}

struct TimeLinePost : Convertible {
    var created_at : String?
    var id : String?
    var idstr : String?
    var mid : String?
    var can_edit : Bool = false
    var show_additional_indication  : String?
    var text : String?
    var textLength : String?
    var source_allowclick : String?
    var source_type : String?
    var source : String?
    var favorited : Bool = true
    var truncated : Bool = false
    var in_reply_to_status_id : String?
    var in_reply_to_user_id : String?
    var in_reply_to_screen_name : String?
    
    var pic_urls : [PostPic] = []
    var bmiddle_pic : String? // 中间清晰度
    var original_pic : String? // 原图
    var geo : weiboGEO?
    var is_paid : Bool = false
    var mblog_vip_type : String?
    
    var user : User?
    
    var picStatus : String?
    var  reposts_count : String = "0"
    var  comments_count : String  = "0"
    var  reprint_cmt_count : String  = "0"
    var  attitudes_count : String = "0"
    var  pending_approval_count : String?
    var  isLongText : Bool = false
    var  reward_exhibition_type : String?
    var  hide_flag : String?
    var  mlevel : String?
    var  biz_feature : String?
    var  hasActionTypeCard : String?
    
    var  positive_recom_flag : String?
    var  enable_comment_guide : Bool = false
    var  content_auth: String?
    var  gif_ids: String?
    var  is_show_bulletin: String?
    var  pic_num : Int = 0
    
    var  reprint_type : String?
    var  can_reprint : Bool = false
    var  new_comment_style : String?
    
}

struct TimeLineResponse : Convertible{
    var statuses : [TimeLinePost] = []
    var ad : [Weibo_ADPost] = []
    var total_number : String?
}


struct PostPic : Convertible {
    var thumbnail_pic : String? //缩略图图片
}


struct weiboGEO : Convertible{
    var   longitude    : String?    //经度坐标
    var   latitude    : String?    //维度坐标
    var   city    : String?    //所在城市的城市代码
    var   province    : String?    //所在省份的省份代码
    var   city_name    : String?    //所在城市的城市名称
    var   province_name    : String?    //所在省份的省份名称
    var   address    : String?    //所在的实际地址，可以为空
    var   pinyin    : String?    //地址的汉语拼音，不是所有情况都会返回该字段
    var   more    : String?    //更多信息，不是所有情况都会返回该字段
}
