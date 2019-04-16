//
//  ViewController.swift
//  workDictionary
//
//  Created by Fan Wu on 9/13/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit
import EventKitUI
import SafariServices
import WebKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, ButtonsPopoverControllerDelegate, WKNavigationDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

//        let abc = SliderWithIndicators(sliderStep: 10, balance: 1000, price: 3)
//        view.addSubview(abc)
//        abc.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        abc.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
//        abc.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
//        abc.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
//        let v1 = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
//        let v2 = "http://techslides.com/demos/sample-videos/small.mp4"
//        let v3 = "https://footy11.videostreamlet.net/player/html/hRD8F4KxX3"
//
//        if let videoURL = URL(string: v1) {
//            print(2222)
//            let player = AVPlayer(url: videoURL)
//            avC.player=player
//            present(avC, animated: true) {
//                print(2222222)
//                self.avC.player?.play()
//            }
//        } else {
//            print(11111)
//        }
    }
    
    deinit {
        webProgressView.isHidden = true
        //remove all observers
        //if the it is in a root View Controller, you might need to use ViewWillDisappear and viewWillAppear
        myWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func setupViews() {
        //Add Bar Buttons
        let addToCalendarBarButtonItem = UIBarButtonItem(image: UIImage(named: "calendar"), style: .done, target: self, action: #selector(addToCalendar))
        self.navigationItem.leftBarButtonItem  = addToCalendarBarButtonItem
        
        let popOverBarButtonItem = UIBarButtonItem(title: "Pop", style: .done, target: self, action: #selector(popover))
        self.navigationItem.rightBarButtonItem  = popOverBarButtonItem
        
        //add progressbar to the Navigation Bar
        navigationController?.navigationBar.addSubview(webProgressView)
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        webProgressView.frame = CGRect(x: 0, y: navigationBarBounds!.size.height - 2, width: navigationBarBounds!.size.width, height: 2)
        //ajust the Progress Bar's height
        webProgressView.transform = webProgressView.transform.scaledBy(x: 1, y: 2)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: Add Event to Calendar and Alert Examples
    //need to set up in info.plist
    @objc func addToCalendar(_ sender: UIBarButtonItem) {
        let startD = Date()
        let endD = Date()
        addEventToCalendar(title: "my title", description: "eat at chinatown", startDate: startD, endDate: endD) { (success, error) in
            //Alert examples
            if success {
                let alert = UIAlertController(title: "Success!", message: "This Event has been added to your Calendar!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Fail!", message: "Sorry, it is fail to add this Event to your Calendar!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { () -> Void in
            let eventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                } else {
                    completion?(false, error as NSError?)
                }
            })
        }
    }
    
    // MARK: Pop Over
    @objc func popover(_ sender: UIBarButtonItem) {
        let popoverController = ButtonsPopoverController()
        popoverController.modalPresentationStyle = .popover
        popoverController.popoverPresentationController?.delegate = self
        popoverController.delegate = self
        //tell the popover where to point
        popoverController.popoverPresentationController?.barButtonItem = sender
        popoverController.buttonTitles = ["aaa", "bbb"]
        popoverController.popoverBarButtonItem = sender
        self.present(popoverController, animated: true)
    }
    
    //a function of PopoverControllerDelegate
    func popoverButtonAction(sender: UIButton) {
        print(sender.currentTitle ?? "Nothing...")
    }
    
    //a function of UIPopoverPresentationControllerDelegate to make sure the iphone also shows the view as a popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: Button
    //a button with title and image
    var hostPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        let tintedImage = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        return button
    }()
    
    @objc func buttonAction() {
        print(111111)
    }
    
    // MARK: Safari
    func goToSafari(url: String) {
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url)
            if #available(iOS 11.0, *) {
                vc.dismissButtonStyle = .close
            }
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            present(vc, animated: true)
        }
    }
    
    // MARK: Web View & ProgressBar
    private lazy var myWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .red
        if let webUrl = URL(string: "webUrl") {
            webView.load(URLRequest(url: webUrl))
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    private var webProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = .blue
        progressView.isHidden = true
        return progressView
    }()
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webProgressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webProgressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webProgressView.isHidden = true
        let alert = UIAlertController(title: "Fail!", message: "Sorry, it was fail to load the Event Web", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            webProgressView.progress = Float(myWebView.estimatedProgress)
        }
    }
    
    //MARK: concurrent Multi-loadings, and wait until all are done
//    fileprivate func getMapsPlaceDetail(completion: @escaping ()->()) {
//        if let mapsResult = mapsSearchResult {
//            if mapsResult.maps.count > 0 {
//                ProgressHud.processing(to: view, msg: "Loading Maps' Data...")
//                let myGroup = DispatchGroup()   //***//
//                mapsSearchResult?.maps.forEach({ (map) in
//                    myGroup.enter()   //***//
//                    DataCenter.shared.getMapDetailBy(map.id, completion: { (jsonData, error) in
//                        if let json = jsonData {
//                            let updatedMap = MapDetailResult(json).map
//                            self.mapsSearchResult?.updateMap(updatedMap)
//                        } else {
//                            ProgressHud.message(to: self.resultsTableView, msg: error?.localizedDescription)
//                        }
//                        myGroup.leave()   //***//
//                    })
//                })
//                //it will wait until myGroup is clear   //***//
//                myGroup.notify(queue: .main) {
//                    ProgressHud.hideProcessing(to: self.view)
//                    completion()
//                }
//            } else {
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
}
