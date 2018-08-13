//
//  UIView+Helpers.swift
//  Call Logger
//
//  Created by Phil Scarfi on 5/31/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    public func addDefaultBackgroundGradient() {
        let gradientLayer = CAGradientLayer()
        backgroundColor = UIColor.white
        gradientLayer.frame = self.bounds
        
        let color1 = UIColor.darkBlue.cgColor
        let color2 = UIColor.lightBlue.cgColor
        
        gradientLayer.colors = [color1,color2]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public func addBottomBorder(thickness: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        border.backgroundColor = color.cgColor
        layer.addSublayer(border)
    }
    
    public func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }

}
