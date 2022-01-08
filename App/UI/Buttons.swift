//
//  Buttons.swift
//  Fantline
//
//  Created by 赵翔宇 on 2021/12/25.
//

import SwiftUI



struct MainButton : View{
    var title : String
    var color : Color = .MainColor
    var iconname : String? = nil
    let action : ()->()
  
    init(title : String,color : Color = .MainColor,iconname : String? = nil,action: @escaping ()->()){
        self.title = title
        self.color = color
        self.action = action
        self.iconname = iconname
    }
    var body: some View{
        
        Button {
            action()
            madasoft()
        } label: {
            HStack{
                if let iconname = iconname {
                    ICON(name: iconname ,fcolor: .white,size: 24)
                }
                Text(title)
                    .mFont(style: .Title_17_B,color: .white)
            }
            
        }
        .buttonStyle(MainButtonStyle(color))

       
     
        
    }
}

struct MainButtonStyle : ButtonStyle{
    let color : Color
    init(_ color : Color = .MainColor){
        self.color = color
    }
    func makeBody(configuration: Configuration) -> some
    View {
        let isPressed = configuration.isPressed
        HStack{
            Spacer()
            configuration
                .label
            Spacer()
        }
        .frame( height: GoldenH)
            .background(color)
            .clipShape(Capsule(style: .continuous))
            .opacity(isPressed ? 0.8 : 1)
            .scaleEffect(isPressed ? 0.98 : 1)
            
    }
}




struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(title: "MainButton"){}
            .previewLayout(.sizeThatFits)
    }
}

