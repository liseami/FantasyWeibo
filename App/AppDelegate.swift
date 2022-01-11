//
//  App.swift
//  TimeMachine (iOS)
//
//  Created by Liseami on 2021/10/1.
//

import Foundation
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate,WeiboSDKDelegate {
    
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
        print(request)
        print("🦢🦢🦢🦢🦢🦢🦢1")
        WeiboLogin.shared.token2 = request?.description ?? "123"
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
//        if response.isKindOfClass(WBAuthorizeResponse){
//            if (response.statusCode == WeiboSDKResponseStatusCode.Success) {
//                var authorizeResponse : WBAuthorizeResponse = response as! WBAuthorizeResponse
//                var userID = authorizeResponse.userID
//                var accessToken = authorizeResponse.accessToken
//                println("userID:\(userID)\naccessToken:\(accessToken)")
//                var userInfo = response.userInfo as Dictionary
//                NSNotificationCenter.defaultCenter().postNotificationName("SINA_CODE", object: nil, userInfo: userInfo)
//            }
//        }
        guard response != nil else {return}
        if response!.isKind(of: WBAuthorizeResponse.self){
            if (response!.statusCode == WeiboSDKResponseStatusCode.success){
                let  authorizeResponse : WBAuthorizeResponse = response as! WBAuthorizeResponse
                let userID = authorizeResponse.userID
                let accessToken = authorizeResponse.accessToken
                print("userID:\(userID)\naccessToken:\(accessToken)")
                let userInfo = response!.userInfo! as Dictionary
                
            }
        }
        WeiboLogin.shared.token = response?.description ?? "123"
    }
    
    

    
    
    var window:UIWindow?
    
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
//
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp("1861925073", universalLink: "/")
        
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: self)
    }
  
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
              return Device.deviceType == .ipad
                  ? UIInterfaceOrientationMask.all
        : UIInterfaceOrientationMask.portrait
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if MobClick.handle(url){
            return true
        }
       
        return true
    }
    
    //    /// 设置屏幕支持的方向
    //        func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    //            if isForceAllDerictions == true {
    //                return .all
    //            } else if isForceLandscape == true {
    //                return .landscape
    //            } else if isForcePortrait == true {
    //                return .portrait
    //            }
    //            return .portrait
    //        }
    
    
    
}
