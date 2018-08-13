//
//  InstagramMedia.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/9/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public struct InstagramUser {
    let id: String
    let username: String
    let fullName: String
    let profilePicture: String
    let bio: String?
    let website: String?
    let mediaCount: Int?
    let follows: Int?
    let followedBy: Int?
}

public struct InstagramMedia {
    let rawDict: [String:Any]
    let id: String
    let postedBy: InstagramUser
    let timestamp: String
    let text: String
    let thumbnailURL: String
    let standardContentURL: String
    let numberOfLikes: Int
    let link: String
    let type: String
}
