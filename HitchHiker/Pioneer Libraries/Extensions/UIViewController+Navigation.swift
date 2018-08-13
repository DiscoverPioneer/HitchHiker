//
//  UIViewControllers+Navigation.swift
//  Call Logger
//
//  Created by Phil Scarfi on 5/1/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit


public enum ViewControllers: String {
    case Signup = "SignupVC"
    case Login = "LoginVC"
    case Posts = "PostsVC"
    case Connections = "ConnectionsVC"
}


public extension UIViewController {
    public func addChildPage(page: ViewControllers, animated: Bool) {
        if let storyBoard = storyboard {
            let vcToNavigateTo = storyBoard.instantiateViewController(withIdentifier: page.rawValue)
            addChildViewController(vcToNavigateTo)
            vcToNavigateTo.view.frame = view.frame
            view.addSubview(vcToNavigateTo.view)
            vcToNavigateTo.didMove(toParentViewController: self)
        } else {
            print("No Storyboard Found")
        }
    }
    
    public func presentPage(page: ViewControllers, animated: Bool) {
        if let storyBoard = storyboard {
            let vcToNavigateTo = storyBoard.instantiateViewController(withIdentifier: page.rawValue)
            present(vcToNavigateTo, animated:animated , completion: nil)
        } else {
            print("No Storyboard Found")
        }
    }
    
    public func navigateToPage(page: ViewControllers) -> UIViewController? {
        if let storyBoard = storyboard {
            let vcToNavigateTo = storyBoard.instantiateViewController(withIdentifier: page.rawValue)
            navigationController?.pushViewController(vcToNavigateTo, animated: true)
            return vcToNavigateTo
        } else {
            print("No Storyboard Found")
            return nil
        }
    }
    
    public func popPage(animated: Bool) -> UIViewController? {
        return navigationController?.popViewController(animated: animated)
    }
    
    public func addChildVC(vc: UIViewController, toView containerView: UIView) {
        addChildViewController(vc)
        let frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        print("Container Frame = \(containerView.frame)")
        vc.view.frame = frame
        containerView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
}

extension UIViewController {
    class func instantiateFromMainStoryboard() -> Self? {
        return initiateFromStoryboardHelper(name: "Main", viewControllerId: String(describing: self))
    }
    
    class func instantiateFromMainStoryboard(id: String) -> Self? {
        return initiateFromStoryboardHelper(name: "Main", viewControllerId: id)
    }
    
    func showBasicAlert(title: String? = nil, message: String? = nil, dismissed: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default) { (action) in
            dismissed?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction], cancel: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        if cancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

private extension UIViewController {
    class func initiateFromStoryboardHelper<T>(name storyboardName: String, viewControllerId: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? T else {
            return nil
        }
        return viewController
    }
}
