//
//  PostMods.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation


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

struct getPostDetailReqMod : Convertible{
    var access_token : String?    /// 采用OAuth授权方式为必填参数，OAuth授权后获得。
    var id : Int?  // 需要获取的微博ID。
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


struct PostDetailMod : Convertible{
    var  created_at : String?
    var  id  : Int?
      var  text : String?
      var  source : String?
    var  favorited: Bool = false
    var  truncated : Bool = false
      var  in_reply_to_status_id : String?
      var  in_reply_to_user_id : String?
      var  in_reply_to_screen_name : String?
    var  geo : weiboGEO?
      var  mid  : String?
      var  reposts_count  : String?
      var  comments_count : String?
     var  annotations : [String]?
    var user : User?
    
}

struct TimeLinePost : Convertible {
    var created_at : String?
    var id : Int?
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

