//
//  InstagramLoginViewController.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/8/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import UIKit

protocol InstagramLoginViewControllerDelegate {
    func instagramLoginVCDidCancel()
    func instagramLoginVC(didGetToken token: String)
    func instagramLoginVCFailedToGetToken(instagramLoginVC: InstagramLoginViewController)
}


class InstagramLoginViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let clientID: String
    let redirectURI: String
    var delegate: InstagramLoginViewControllerDelegate?
    
    init(clientID: String, redirectURI: String, delegate: InstagramLoginViewControllerDelegate? = nil) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadLoginPageWith(clientID: clientID, redirectURI: redirectURI)
    }

    private func setupView() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(InstagramLoginViewController.cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        
        let webView = UIWebView(frame: view.frame)
        webView.delegate = self
        view.addSubview(webView)
        self.webView = webView
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = UIColor.darkGray
        spinner.center = webView.center
        spinner.hidesWhenStopped = true
        webView.addSubview(spinner)
        self.spinner = spinner
    }
}

//MARK: - WebView Delegate
extension InstagramLoginViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestIsGood = checkRequestForCallbackURL(request: request)
        return requestIsGood
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed to load: \(error)")
        spinner.stopAnimating()
    }
    
}


//MARK: - Functions
extension InstagramLoginViewController {
    @objc func cancelAction() {
        navigationController?.dismiss(animated: true, completion: nil)
        delegate?.instagramLoginVCDidCancel()
    }
    
    fileprivate func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let givenRedirectURI = self.redirectURI.lowercased()
        if let requestURLString = (request.url?.absoluteString)?.lowercased(), requestURLString.hasPrefix(givenRedirectURI) {
            if let range: Range<String.Index> = requestURLString.range(of: "#access_token=") {
                let token = requestURLString.substring(from: range.upperBound)
                print("Found Token \(token)")
                delegate?.instagramLoginVC(didGetToken: token)
            } else {
                print("Couldnt find token from request \(request)")
                delegate?.instagramLoginVCFailedToGetToken(instagramLoginVC: self)
            }
            navigationController?.dismiss(animated: true, completion: nil)
            return false
        }
        return true
    }
    
    fileprivate func loadLoginPageWith(clientID: String, redirectURI: String) {
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        let urlStr = "https://api.instagram.com/oauth/authorize/?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=token"
        if let url = URL(string: urlStr) {
            webView.loadRequest(URLRequest(url: url))
        }
    }
}

