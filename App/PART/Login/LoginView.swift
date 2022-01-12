//
//  LoginView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/7.
//

import SwiftUI
import FantasyUI







struct LoginView: View {
    
    @State private var step : Int = 0
    @ObservedObject var vm = WeiboLoginViewModel.shared

    var body: some View {
        
        
        ZStack{
            VStack{
                
                
                Link(destination: URL(string: "https://weibo.com/u/2483613420")!) {
                                  Text("最新进展")
                              }
                .mFont(style: .Title_17_B,color: .MainColor)
                .frame(maxWidth:.infinity,alignment: .trailing)
                
                
                Spacer()
                Text("面向未来的，另一个微博客户端。用严苛的极简，更新你的微博体验。")
                        .mFont(style: .largeTitle_24_B,color: .fc1)
                        .ifshow(step == 0, animation: .spring(), transition: .move(edge: .top))
                
                Spacer()
                
                VStack{
                    MainButton(title: "链接新浪微博账户",iconname: "WeiboLogo") {
                        linkWeibo()
                    }
                    Text("基于新浪公司微博Api打造")
                        .mFont(style: .Body_15_R,color: .fc3)
                }
                .ifshow(step == 0, animation: .spring(), transition: .move(edge: .bottom))
                
            }
            .padding(.all,24)
            
            
            Color.MainColor
                .frame( maxHeight: step > 1 ? .infinity : 12 )
                .overlay(loginWebView)
                .clipShape( RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal,12)
                .shadow(color: step > 2 ? .fc1.opacity(0.2) : .clear, radius: 12, x: 0, y: 2)
                .ifshow(step > 0, animation: .spring(), transition: .move(edge: .leading))
            
                
        }
    }
    
    
    ///WKWebView
    var loginWebView : some View {
        ZStack{
            Webview(url: URL(string: "https://weibo.com/u/2483613420")!)
                .clipped()
                .ifshow(step == 3)
            ProgressView()
                .ifshow(step == 2)
            closeBtn
        }
    }
    
    ///关闭按钮
    var closeBtn : some View {
        Button {
            withAnimation(.spring()){
                step = 0
            }
        } label: {
            ICON(sysname: "xmark",fcolor: .fc1,size: 16,fontWeight: .semibold)
                .padding(.all,8)
                .background(BlurView().clipShape(Circle()))
        }
        .MoveTo(.topTrailing)
        .padding()
        .ifshow(step >= 3)
    }
    
    ///点击链接按钮
    func linkWeibo(){
        withAnimation {
            madasoft()
            step += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                step += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        step += 1
                        //跳转至微博
                        vm.login()
                    }
                }
            }
        }
       
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


class WeiboLoginViewModel :NSObject,WeiboSDKDelegate, ObservableObject{
    
    static let shared = WeiboLoginViewModel()
    
    
    ///跳转至微博认证
    func login(){
        let request : WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
        request.userInfo = ["SSO_Key":"SSO_Value"]
        WeiboSDK.send(request) { _ in
            print("🦢🦢🦢🦢🦢🦢🦢 - 发出链接微博的请求")
        }
        
    }
    
    /// 微博链接回调🔗🔗🔗🔗🔗🔗🔗🔗🔗
    func didReceiveWeiboResponse(_ response: WBBaseResponse?) {
             madaSuccess()
            print("🦢🦢🦢🦢🦢🦢🦢didReceiveWeiboResponse")
            guard response != nil else {return}
            if response!.isKind(of: WBAuthorizeResponse.self){
                if (response!.statusCode == WeiboSDKResponseStatusCode.success){
                    let  authorizeResponse : WBAuthorizeResponse = response as! WBAuthorizeResponse
                    let userID = authorizeResponse.userID
                    let accessToken = authorizeResponse.accessToken
                    if let token = accessToken{
                        UserManager.shared.token = token
                    }
                    print("userID:\(String(describing: userID))\naccessToken:\(String(describing: accessToken))")
                }
            }
            madaSuccess()
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest?) {
        print("🦢🦢🦢🦢🦢🦢🦢didReceiveWeiboRequest")    }
    
    
}
