//
//  PostMods.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation


struct getTimeLineReqMod : Convertible{
    var access_token : String = ""    /// 采用OAuth授权方式为必填参数，OAuth授权后获得。
    var since_id     : Int?       ///若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    var max_id       : Int?       ///若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    var count        : Int?       ///单页返回的记录条数，最大不超过100，默认为20。
    var page         : Int?       ///返回结果的页码，默认为1。
    var base_app     : Int?       ///是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    var feature      : Int?      /// 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    var trim_user    : Int?     /// 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
}

struct getUserTimeLineReqMod : Convertible {
    var access_token : String = ""    /// 采用OAuth授权方式为必填参数，OAuth授权后获得。
    var uid :  String?  ///  需要查询的用户ID。
    var screen_name  : String?   /// 需要查询的用户昵称。
    var since_id     : Int?       ///若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    var max_id       : Int?       ///若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    var count        : Int?       ///单页返回的记录条数，最大不超过100，默认为20。
    var page         : Int?       ///返回结果的页码，默认为1。
    var base_app     : Int?       ///是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
    var feature      : Int?      /// 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
    var trim_user    : Int?     /// 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
}



struct Weibo_ADPost : Convertible{
    var id : String?
    var mark : String?
}

struct Post : Convertible {
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
    var retweeted_status : repostPost?
    var  picStatus : String?
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

struct repostPost : Convertible{
    var created_at:  String? //Thu Jan 13 22:29:48 +0800 2022",
    var id:  String?
    var idstr:  String? //4725305929896095",
    var mid:  String? //4725305929896095",
    var can_edit: Bool = false
    var version:  String?
    var show_additional_indication:  String? //,
    var text:  String = "" //【#男子违规攀爬荆州古城墙#，还发视频“提醒大家不要破坏”】#男子爬古城墙还发视频宣传保护文物#1月12日，有网友向极目新闻爆料称，一男子在荆州古城墙上攀爬拍照，还在某短视频平台发文“提醒大家不要破坏”。在该条短视频的留言区，不少网友提出了批评，并指出可能会对城墙砖体造成破坏。该段视频 ​",
    var textLength:  String?
    var source_allowclick:  String? //,
    var source_type:  String?
    var source:  String? //<a href=\"http://app.weibo.com/t/feed/19DcdW\" rel=\"nofollow\">微博视频</a>",
    var favorited: Bool = false
    var truncated: Bool = false
    var in_reply_to_status_id:  String? //",
    var in_reply_to_user_id:  String? //",
    var in_reply_to_screen_name:  String? //",
    var pic_urls: [PostPic] = []
    var geo : weiboGEO?
    var is_paid: Bool = false
    var mblog_vip_type:  String? //,
    var user:  User?
    var reposts_count:  String?
    var comments_count:  String?
    var reprint_cmt_count:  String? //,
    var attitudes_count:  String?
    var pending_approval_count:  String? //,
    var isLongText: Bool = false
    var reward_exhibition_type:  String? //,
    var hide_flag:  String? //,
    var mlevel:  String? //,
    var biz_feature:  String?
    var page_type:  String?
    var hasActionTypeCard:  String? //,
    var mblogtype:  String? //,
    var rid:  String? //47_0_1_793642448025768005_0_0_0",
    var userType:  String? //,
    var more_info_type:  String? //,
    var cardid:  String? //star_1393",
    var positive_recom_flag:  String? //,
    var content_auth:  String? //,
    var gif_ids:  String? //",
    var is_show_bulletin:  String?
    var pic_num:  String? //,
    var fid:  String?
    var reprint_type:  String? //,
    var can_reprint: Bool = false
    var new_comment_style:  String? //
    
}

struct TimeLineResponse : Convertible{
    var statuses : [Post] = []
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


