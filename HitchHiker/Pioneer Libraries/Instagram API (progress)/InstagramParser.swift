//
//  InstagramParser.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/9/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public class InstagramParser {
    public func parseUserDict(dict: [String: Any]) -> InstagramUser? {
        if let fullName = dict["full_name"] as? String,
            let id = dict["id"] as? String,
            let profilePicURL = dict["profile_picture"] as? String,
            let userName = dict["username"] as? String {
            let bio = dict["bio"] as? String
            let website = dict["website"] as? String
            let counts = dict["counts"] as? [String:Int]
            let mediaCount = counts?["media"]
            let follows = counts?["follows"]
            let followedBy = counts?["followed_by"]
            return InstagramUser(id: id, username: userName, fullName: fullName, profilePicture: profilePicURL, bio: bio, website: website, mediaCount: mediaCount, follows: follows, followedBy: followedBy)
        }
        return nil
    }
    
    public func parseMediaDict(dict: [String: Any]) -> InstagramMedia? {
        if let caption = dict["caption"] as? [String:Any],
            let createdTimestamp = dict["created_time"] as? String,
            let from = caption["from"] as? [String:Any],
            let user = parseUserDict(dict: from),
            let id = dict["id"] as? String,
            let text = caption["text"] as? String,
            let images = dict["images"] as? [String:[String:Any]],
            let thumbnailURL = images["thumbnail"]?["url"] as? String,
            let standardURL = images["standard_resolution"]?["url"] as? String,
            let likes = dict["likes"] as? [String:Any],
            let numberOfLikes = likes["count"] as? Int,
            let link = dict["link"] as? String,
            let type = dict["type"] as? String
        {
        
            return InstagramMedia(rawDict: dict, id: id, postedBy: user, timestamp: createdTimestamp, text: text, thumbnailURL: thumbnailURL, standardContentURL: standardURL, numberOfLikes: numberOfLikes, link: link, type: type)
        }
        return nil
        
    }
}











