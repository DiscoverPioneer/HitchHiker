//
//  Numbers+Helpers.swift
//  MTFT
//
//  Created by Phil Scarfi on 2/18/20.
//  Copyright © 2020 Pioneer Mobile Applications, LLC. All rights reserved.
//

import Foundation

extension Double {
    func secondsToMilliseconds() -> Double {
        return self * 1000.0
    }
    
    func millisecondsToSeconds() -> Double {
        return self / 1000.0
    }
}
