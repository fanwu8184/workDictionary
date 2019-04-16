//
//  TestViewController.swift
//  workDictionary
//
//  Created by Fan Wu on 3/4/19.
//  Copyright © 2019 8184. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import AVFoundation

class TestViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!

//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let myURL = URL(string:"https://player.videostreamlet.net/embed/hRD8F4KxX3")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
        
        let avC = AVPlayerViewController()

        let v1 = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        let v2 = "https://player.videostreamlet.net/embed/hRD8F4KxX3"

        if let videoURL = URL(string: v2) {
            print(2222)
            let player = AVPlayer(url: videoURL)
            avC.player=player
            present(avC, animated: true) {
                print(2222222)
                avC.player?.play()
            }
        } else {
            print(11111)
        }
    }
}
