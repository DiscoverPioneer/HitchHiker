//
//  UIButton+Helpers.swift
//  MTFT
//
//  Created by Phil Scarfi on 2/21/20.
//  Copyright © 2020 Pioneer Mobile Applications, LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func addFloatingButtonToView(view: UIView, size: CGFloat = 50) {
        //Currently only supports adding to bottom right
        titleEdgeInsets = UIEdgeInsets(top: -5.0, left: 0.0, bottom: 0.0, right: 0.0)
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
            
        ])
        
        layer.cornerRadius = size / 2
        clipsToBounds = true
    }
}
