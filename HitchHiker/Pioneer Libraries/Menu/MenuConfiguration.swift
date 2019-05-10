//
//  MenuConfiguration.swift
//  NYCFireWire
//
//  Created by Phil Scarfi on 9/13/18.
//  Copyright © 2018 Pioneer Mobile Applications, LLC. All rights reserved.
//

import Foundation

class MenuOptions {
    static let labels = ["Home", "Favorites", "Settings", "Support", "Log out"]
    static let version = "Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unkown")"
    static let viewControllers = [
        DashboardViewController.instantiateFromMainStoryboard()!,
        DashboardViewController.instantiateFromMainStoryboard()!,
        DashboardViewController.instantiateFromMainStoryboard()!,
        DashboardViewController.instantiateFromMainStoryboard()!
                                  ]
}
