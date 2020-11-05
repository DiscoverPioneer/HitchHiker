//
//  StackedScrollView.swift
//  TabUpServer
//
//  Created by Phil Scarfi on 7/22/20.
//  Copyright © 2020 Pioneer Mobile Applications, LLC. All rights reserved.
//

import UIKit

class StackedScrollView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    func setupView(allViews: [UIView], isVertical: Bool, spacing: CGFloat = 10) {
        let scrollView = UIScrollView(frame: frame)
        addSubview(scrollView)
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let stackView = UIStackView(frame: frame)
        scrollView.addSubview(stackView)
        stackView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        if isVertical {
            stackView.axis = .vertical
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        } else {
            stackView.axis = .horizontal
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        }
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing

        for view in allViews {
                   stackView.addArrangedSubview(view)
       }
        
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
        self.scrollView = scrollView
        self.stackView = stackView
    }

}
