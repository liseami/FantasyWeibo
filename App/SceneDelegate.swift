//
//  SceneDelegate.swift
//  FantasyTikTok
//
//  Created by 赵翔宇 on 2022/1/12.
//

import Foundation
import FantasyUI



class SceneDelegate: NSObject, UIWindowSceneDelegate,ObservableObject{
   
    
  func sceneWillEnterForeground(_ scene: UIScene) {
    // ...
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // ...
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // ...
  }
    
    
    //微博返回App时，接收URL，交给WeiboSDK处理，由WeiboLogin.shared监听处理结果
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
      if let url = URLContexts.first?.url{
          WeiboSDK.handleOpen(url, delegate: WeiboLoginViewModel.shared)
      }
  }


    
}

//486c2c9586ba8d810qcs99Qd6vYNzvm9rAiT
//486c2c9586ba8d81FvGa3iptDb7TTOtvQXZJ
//486c2c9586ba8d81sniB8oLqQaxuxJ4naPtK
