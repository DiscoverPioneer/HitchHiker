//
//  UIViewController+Inherited.swift
//  Call Logger
//
//  Created by Phil Scarfi on 5/1/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import MessageUI


extension UINavigationItem {



 func setTitle(_ title: String, subtitle: String) {
   let appearance = UINavigationBar.appearance()
   let textColor = appearance.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor ?? .white

   let titleLabel = UILabel()
   titleLabel.text = title
    titleLabel.textColor = .white
   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
   titleLabel.textColor = textColor

   let subtitleLabel = UILabel()
   subtitleLabel.text = subtitle
    subtitleLabel.textColor = .white
   subtitleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
   subtitleLabel.textColor = textColor.withAlphaComponent(0.75)

   let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
   stackView.distribution = .equalCentering
   stackView.alignment = .center
   stackView.axis = .vertical

   self.titleView = stackView
 }
}

extension UIViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func setNavBarTitle(title: String, subtitle: String? = nil) {

        navigationController?.navigationBar.barTintColor = .primaryColor
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.white
                    ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        tabBarController?.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = title
        UINavigationBar.appearance().isTranslucent = false
        if let subtitle = subtitle {
            navigationItem.setTitle(title, subtitle: subtitle)
        }

    }
}

extension UIViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Received response \(response)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Presenting... \(notification)")
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
   
    
    func sendEmail(to: String, subject: String, message:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([to])
            mail.setSubject(subject)
            mail.setMessageBody(message, isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("FInishe")
        controller.dismiss(animated: true, completion: nil)
    }
    
    //SMS
    func sendSMSText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
           self.dismiss(animated: true, completion: nil)
       }

}
