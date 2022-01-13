//
//  UserMods.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/13.
//

import Foundation


struct status_total_counter : Convertible{
    var total_cnt : String = "0"//
    var repost_cnt : String = "0"//
    var comment_cnt : String = "0"//
    var like_cnt : String = "0"//
    var comment_like_cnt : String = "0"//
}

struct video_total_counter : Convertible{
    var play_cnt : String = "0"//
}

struct User : Convertible{
    var id: String? //
    var idstr: String? //
    //   var class: String? //
    var screen_name: String? //
    var name: String? //
    var province: String? //31
    var city: String? //1000
    var location: String? //上海
    var description: String? //www.revome.com
    var url: String? //
    var profile_image_url: String? //https://tvax2.sinaimg.cn/crop.0.0.1080.1080.50/9408eeecly8gy1h6u2k9oj20u00u044g.jpg?KID=imgbed,tva&Expires=1642051049&ssig=kpD5UwF52C
    var cover_image: String? //http://wx1.sinaimg.cn/crop.0.0.920.300/9408eeecgy1ff65abhpdij20pk08ck9b.jpg
    var cover_image_phone: String? //http://ww1.sinaimg.cn/crop.0.0.640.640.640/9d44112bjw1f1xl1c10tuj20hs0hs0tw.jpg
    var profile_url: String? //274300559
    var domain: String? //
    var weihao: String? //274300559
    var gender: String? //m
    var followers_count: String = "0" //9517,
    var followers_count_str: String = "0"//2万
    var friends_count: String? //4,
    var pagefriends_count: String? //,
    var statuses_count: String = "" //48,
    var video_status_count: String? //,
    var video_play_count: String? //,
    var favourites_count: String? //7,
    var created_at: String? //Fri Oct 21 20:57:37 +0800 2011
    var following  : Bool = false
    var allow_all_act_msg  : Bool = false
    var geo_enabled  : Bool = false
    var verified  : Bool = false
    var verified_type: String? //,
    var remark: String? //
    //   var insecurity":{},
    //   var status":{},
    var ptype: String? //,
    var allow_all_comment  : Bool = false
    var avatar_large: String? //https://tvax2.sinaimg.cn/crop.0.0.1080.1080.180/9408eeecly8gy1h6u2k9oj20u00u044g.jpg?KID=imgbed,tva&Expires=1642051049&ssig=%2BV406ApylX
    var avatar_hd: String? //https://tvax2.sinaimg.cn/crop.0.0.1080.1080.1024/9408eeecly8gy1h6u2k9oj20u00u044g.jpg?KID=imgbed,tva&Expires=1642051049&ssig=Fhr2NFHEUH
    var verified_reason: String? //青年作家
    var verified_trade: String? //2015
    var verified_reason_url: String? //
    var verified_source: String? //
    var verified_source_url: String? //
    var verified_state: String? //,
    var verified_level: String? //,
    var verified_type_ext: String? //,
    var has_service_tel  : Bool = false
    var verified_reason_modified: String? //
    var verified_contact_name: String? //
    var verified_contact_email: String? //
    var verified_contact_mobile: String? //
    var follow_me  : Bool = false
    var like  : Bool = false
    var like_me  : Bool = false
    var online_status: String? //,
    var bi_followers_count: String = "" //,
    var lang: String? //zh-tw
    var star: String? //,
    var mbtype: String? //,
    var mbrank: String? //,
    var svip: String? //,
    var block_word: String? //,
    var block_app: String? //,
    var ability_tags: String? //文学,诗歌,小说,纪实文学,散文
    var credit_score: String? //7,
    var user_ability: String? //0749448,
    var urank: String? //4,
    var story_read_state : String?
    //   var verified_detail":{},
    var vclub_member: String? //,
    var is_teenager: String? //,
    var is_guardian: String? //,
    var is_teenager_list: String? //,
    var pc_new: String? //,
    var special_follow  : Bool = false
    var planet_video: String? //,
    var video_mark: String? //4,
    var live_status: String? //,
    var user_ability_extend: String? //,
    var status_total_counter : status_total_counter?
    var video_total_counter : video_total_counter?
    var brand_account: String? //,
    var hongbaofei: String? //
}

