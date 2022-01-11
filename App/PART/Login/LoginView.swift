//
//  LoginView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/7.
//

import SwiftUI
import FantasyUI



class LoginViewModel : ObservableObject{
    static let shared = LoginViewModel()
    @Published var  html5 : String?
    
    func getoauth2_authorize(){
        let target = LoginApi.login(p: .init(client_id: "1861925073", redirect_uri: "https://api.weibo.com/oauth2/default.html", scope: "all",display: "mobile"))
        Networking.request(target) { result in
            self.html5 =  result.rawData as? String
            print("🦢")
            switch result{
            case .success( let response):
                if let data = String(data: response.data, encoding: .utf8) {
                    self.html5 = data
                }
            case .failure(_): break
                
            }
        }
    }
}

enum LoginApi : ApiType{
    
    case login(p:LoginReqModel)
    
    var path: String {
           "oauth2/authorize"
    }
    
    var method: HTTPRequestMethod{
        .get
    }
    
    var parameters: [String : Any]?{
        switch self {
        case .login(let p):
            return p.kj.JSONObject()
        }
    }
    
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.default
    }
   
    
}

struct LoginReqModel : Convertible{
    var client_id : String = ""
    var redirect_uri : String = ""
    var scope : String = ""
    var display : String = ""
}

struct LoginResponseModel : Convertible{
    var code : String = ""
    var state : String = ""
}




struct LoginView: View {
    
    
    @State private var step : Int = 0
    
    
    @ObservedObject var vm = WeiboLogin.shared
//    @ObservedObject var vm = LoginViewModel.shared
    var body: some View {
        
        
        ZStack{
            VStack{
                
                
//                Link(destination: URL(string: "https://Twitter.com/liseami1")!) {
//                    Text("最新进展")
//                }
                
                Button("最新进展"){
                    UIState.shared.logged = true
                }
                .mFont(style: .Title_17_B,color: .MainColor)
                .frame(maxWidth:.infinity,alignment: .trailing)
                
                
                Spacer()
                Text(vm.token)
                Text(vm.token2)
                Text("面向未来的，另一个微博客户端。用严苛的极简，更新你的微博体验。")
                        .mFont(style: .largeTitle_24_B,color: .fc1)
                        .ifshow(step == 0, animation: .spring(), transition: .move(edge: .top))
                
                Spacer()
                
                VStack{
                    MainButton(title: "链接新浪微博账户",iconname: "WeiboLogo") {
//
//                        vm.getoauth2_authorize()
                        vm.login()
//                        linkWeibo()
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
//            WebviewHTML(HTMLString: vm.html5 ?? "<!DOCTYPE html><html><head>Loading HTML</head><body><p>Hello!`</p></body></html>")
//                .clipped()
//                .ifshow(step == 3)
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


class WeiboLogin :NSObject, ObservableObject{
    
    
    
    static let shared = WeiboLogin()
    
    @Published var token : String  = ""
    @Published var token2 : String  = ""

    
    func login(){
        let request : WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
        request.userInfo = ["SSO_Key":"SSO_Value"]
        WeiboSDK.send(request) { _ in
            print("🦢🦢🦢🦢🦢🦢🦢4")
        }
        
    }
    
}
