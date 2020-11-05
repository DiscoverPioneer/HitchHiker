//
//  UITableView+Helpers.swift
//  MTFT
//
//  Created by Phil Scarfi on 2/18/20.
//  Copyright © 2020 Pioneer Mobile Applications, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func addPullToRefresh(target: Any?, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    func setEmptyMessage(_ message: String?) {
        guard let message = message else {
            self.backgroundView = nil
            return
        }
        self.backgroundView?.removeFromSuperview()
        backgroundView = nil
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func registerNib(name: String, cellID: String? = nil) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: cellID ?? name)
    }
}
