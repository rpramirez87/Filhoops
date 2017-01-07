//
//  HomeVC.swift
//  Filhoops
//
//  Created by Ron Ramirez on 11/19/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
import Firebase

class HomeVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var container : UIView!
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Filhoops home page
        let filhoopsURL = "http://filhoopshouston.com/"
        let url = URL(string: filhoopsURL)
        let request = URLRequest(url: url! as URL)
        
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
        
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("User signed out \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goBackToLoginVC", sender: nil)
    }
}
