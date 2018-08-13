//
//  InstagramAuthController.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/9/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit

protocol InstagramAuthControllerDelegate {
    func instagramAuth(didLogin: Bool, token: String?)
}

public class InstagramAuthController {
    fileprivate let clientID: String
    fileprivate let redirectURI: String
    fileprivate var currentVC: UIViewController?
    
    var delegate: InstagramAuthControllerDelegate?
    
    init(clientID: String, redirectURI: String, delegate: InstagramAuthControllerDelegate? = nil) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.delegate = delegate
    }
    
    public func login(vc: UIViewController) {
        self.currentVC = vc
        let instagramVC = InstagramLoginViewController(clientID: clientID, redirectURI: redirectURI, delegate: self)
        let nav = UINavigationController(rootViewController: instagramVC)
        vc.present(nav, animated: true, completion: nil)
    }
}

extension InstagramAuthController: InstagramLoginViewControllerDelegate {
    func instagramLoginVCDidCancel() {
        delegate?.instagramAuth(didLogin: false, token: nil)
    }
    
    func instagramLoginVC(didGetToken token: String) {
        delegate?.instagramAuth(didLogin: true, token: token)
    }
    
    func instagramLoginVCFailedToGetToken(instagramLoginVC: InstagramLoginViewController) {
        delegate?.instagramAuth(didLogin: false, token: nil)
    }
}
