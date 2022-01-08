//
//  ScrollableTabBar.swift
//  MotionDesgin
//
//  Created by 梁泽 on 2021/10/8.
//

import SwiftUI
/*
 the main reason that we have not used the page view style is because it is clearing the previous tab data when a new tab is being swiped
 the solution or fix may be prevoided in the next swiftui release
 another bug with page tab view is. that is not ignoring edges, to avoid this we have created custom view using view builder
 https://www.youtube.com/watch?v=Q6p4QyXa2Po
 https://www.youtube.com/watch?v=80n0zv7r9Lc&t=76s
 */


public struct MT_PageScrollowView<Content: View>: UIViewRepresentable {
    @Binding var offset: CGFloat

    var content: Content
    
    private let scrollView = UIScrollView()
    
    public init( offset: Binding<CGFloat>, @ViewBuilder content:  () -> Content) {
        self._offset = offset
        self.content = content()
    }
    
    public func makeUIView(context: Context) ->  UIScrollView {
        setupScrollView()
        
        let hostVc = UIHostingController(rootView: content)
        hostVc.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostVc.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostVc.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            hostVc.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostVc.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            hostVc.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        
        scrollView.addSubview(hostVc.view)
        scrollView.addConstraints(constraints)
        
        scrollView.delegate = context.coordinator
        return scrollView
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.contentOffset.x != offset {
             uiView.delegate = nil
            UIView.animate(withDuration: 0.25) {
                uiView.contentOffset.x = offset
            } completion: { isCompletion in
                if isCompletion {
                    uiView.delegate = context.coordinator
                }
            }

        }
    }
    
    // setting up scrollView
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
  
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: MT_PageScrollowView
        init(parent: MT_PageScrollowView) {
            self.parent = parent
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
    }
}

