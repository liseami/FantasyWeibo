//
//  MTPageSegmentView.swift
//  MotionComponents
//
//  Created by 梁泽 on 2021/10/8.
//

import SwiftUI


public protocol MTPageSegmentProtocol {
    var showText: String { get }
}

extension String: MTPageSegmentProtocol {
    public var showText: String { self }
}

public struct MT_PageSegmentView: View {
    var titles: [MTPageSegmentProtocol]
    @Binding var offset: CGFloat
    ///可以监听offset算pageindex
    public var pageIndex: Int {
        Int(floor(offset + 0.5) / SW)
    }
    
    public init(titles: [MTPageSegmentProtocol], offset: Binding<CGFloat>) {
        self.titles = titles
        self._offset = offset
    }
    
    public var body: some View {
        GeometryReader { proxy -> AnyView in
            let totalWidth = proxy.frame(in: .global).width
            let equalWidth = totalWidth / CGFloat(titles.count)
            
//            DispatchQueue.main.async {
//                width = equalWidth
//            }
            
            let progress = offset / SW
            let offsetX = progress * equalWidth
            
            return AnyView(
                ZStack(alignment: .bottomLeading) {
                    HStack(spacing: 0 ) {
                        ForEach(titles.indices, id: \.self) { index in
                            let selected = pageIndex  == index
                            Text(titles[index].showText)
                                .mFont(style: .Title_17_B,color: selected ? .fc1 : .fc2)
                                .frame(maxHeight: .infinity)
                                .frame(width: equalWidth, alignment: .center)
                                .onTapGesture {
                                    withAnimation {
                                        offset = SW  * CGFloat(index)
                                    }
                                }
                        }
                    }

                    Divider()
                    
                    Capsule()
                        .foregroundColor(Color.MainColor)
                        .frame(width: equalWidth - 24, height: 3)
                        .offset(x: offsetX + 12)
                }
                    .onChange(of: offset, perform: { newValue in
                        print(pageIndex)
                    })
            )
           
        }
        .frame(height: 44)
    }

}


