//
//  ViewController.swift
//  Project4
//
//  Created by Valeriy Kovalevskiy on 3/11/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    static var webView: WKWebView!
    var progressView: UIProgressView!
    static var websites = ["apple.com" , "sdgsfbsh.com"]
    override func loadView() {
        ViewController.webView = WKWebView()
        ViewController.webView.navigationDelegate = self
        view = ViewController.webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: ViewController.webView, action: #selector(ViewController.webView.reload))
        let back = UIBarButtonItem(barButtonSystemItem: .pause, target: ViewController.webView, action: #selector(ViewController.webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: ViewController.webView, action: #selector(ViewController.webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh, back, forward]
        navigationController?.isToolbarHidden = false
        
        ViewController.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + ViewController.websites[0])!
        ViewController.webView.load(URLRequest(url: url))
        ViewController.webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let storyboard = UIStoryboard(name: "PagesTableViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PagesTableViewController")
        navigationController?.present(vc, animated: true)
//        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
//        for website in websites {
//            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
//
//        }
//        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
//        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//        present(ac, animated: true)
    }
    

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(ViewController.webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in ViewController.websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                } else {
                    let ac = UIAlertController(title: "error", message: "doesnt exists", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            }
        }
        decisionHandler(.cancel)
    }
}

