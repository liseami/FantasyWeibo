//
//  Emoji.swift
//  FantasyWeibo (iOS)
//
//  Created by 赵翔宇 on 2022/1/16.
//

import Foundation




struct Emoji : Convertible{
    
    var phrase: String? //[doge]",
    var type: String? //face",
    var url: String? //https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a1/2018new_doge02_org.png",
    var hot: Bool? = false
    var common : Bool? = false
    var category: String? //",
    var icon: String? //https://face.t.sinajs.cn/t4/appstyle/expression/ext/normal/a1/2018new_doge02_org.png",
    var value: String? //[doge]",
    var picid: String? //"
    
}
