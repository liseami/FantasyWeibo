//
//  FantasyWeiboApp.swift
//  Shared
//
//  Created by 赵翔宇 on 2022/1/8.
//

import SwiftUI
@_exported import FantasyUI

@main
struct FantasyWeiboApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //监控场景阶段
    @Environment(\.scenePhase) var scenePhase
    //一个属性来存储持久化控制器
    let userDefaults = UserDefaults.standard
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            TestTest()
        }
    }
}
