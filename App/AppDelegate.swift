//
//  App.swift
//  TimeMachine (iOS)
//
//  Created by Liseami on 2021/10/1.
//

import Foundation
import UIKit
import FantasyUI


class AppDelegate: NSObject, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        //友盟启动
//        UM_RUN()
//        //AppleStore初始化
//        AppStore_init()
//        //UI调整
        Customappearance()
//
//        //初次登陆检查
        LaunchManager.shared.firstLaunchTest()
        
        //微博SDK日志
        WeiboSDK.enableDebugMode(true)
        //微博SDK注册
        WeiboSDK.registerApp("1861925073", universalLink: "/")
        
        return true
    }

   
    
    
    //    SceneDelegate
        func application(
          _ application: UIApplication,
          configurationForConnecting connectingSceneSession: UISceneSession,
          options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {
          let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
          sceneConfig.delegateClass = SceneDelegate.self // 👈🏻
          return sceneConfig
        }
    
}
