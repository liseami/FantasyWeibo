//
//  WebView.swift
//  FantasyTwitter (iOS)
//
//  Created by 赵翔宇 on 2022/1/7.
//

import SwiftUI
import WebKit



struct Webview: UIViewControllerRepresentable {
    let url: URL
    

    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)

        return webviewController
    }

    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)
    }
}

class WebviewController: UIViewController, WKNavigationDelegate {
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()

    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview)

        self.webview.frame = self.view.frame
        self.webview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.webview.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])

        self.webview.addSubview(self.progressbar)
        self.setProgressBarPosition()

        webview.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)

        self.progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    func setProgressBarPosition() {
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.webview.removeConstraints(self.webview.constraints)
        self.webview.addConstraints([
            self.progressbar.topAnchor.constraint(equalTo: self.webview.topAnchor, constant: self.webview.scrollView.contentOffset.y * -1),
            self.progressbar.leadingAnchor.constraint(equalTo: self.webview.leadingAnchor),
            self.progressbar.trailingAnchor.constraint(equalTo: self.webview.trailingAnchor),
        ])
    }

    // MARK: - Web view progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if self.webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressbar.alpha = 0.0
                }, completion: { finished in
                    self.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressbar.isHidden = false
                self.progressbar.alpha = 1.0
                progressbar.setProgress(Float(self.webview.estimatedProgress), animated: true)
            }

        case "contentOffset":
            self.setProgressBarPosition()

        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}




struct WebviewHTML: UIViewControllerRepresentable {
    let HTMLString : String
    

    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()

        
        webviewController.webview.loadHTMLString(HTMLString, baseURL: nil)

        return webviewController
    }

    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        
        webviewController.webview.loadHTMLString(HTMLString, baseURL: nil)
    }
}


