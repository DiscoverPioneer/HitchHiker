//
//  InstagramAPIController.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/9/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

let InstagramBaseURL = "https://api.instagram.com/v1"
let InstagramLoggedInUserDetailsEndpoint = "/users/self"
let InstagramUsersDetailsEndpoint = "/users/"
let InstagramUsersRecentMediaEndpoint = "/users/$USERID$/media/recent"
let InstagramGetLoggedInUsersLikedMediaEndpoint = "/users/self/media/liked"
let InstagramSearchForUsersEndpoint = "/users/search"

public class InstagramAPIController {
    let networker: InstagramNetworker
    
    public init(accessToken: String) {
        self.networker = InstagramNetworker(accessToken: accessToken)
    }
    
    public func getLoggedInUserDetails(completion:@escaping (_ userDict: [String:Any]?, _ error: String?) -> Void) {
        let url = InstagramBaseURL + InstagramLoggedInUserDetailsEndpoint
        networker.makeGetRequest(url: url, params: []) { (result, error) in
            if let result = result as? [String:Any], error ==  nil {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getUserDetails(userID: String, completion:@escaping (_ userDict: [String:Any]?, _ error: String?) -> Void) {
        let url = InstagramBaseURL + InstagramUsersDetailsEndpoint + userID
        networker.makeGetRequest(url: url, params: []) { (result, error) in
            if let result = result as? [String:Any], error ==  nil {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getLoggedInUserRecentMedia(completion:@escaping (_ mediaItems: [InstagramMedia]?, _ error: String?) -> Void) {
        getUserRecentMedia(userID: "self", completion: completion)
    }
    
    public func getUserRecentMedia(userID: String, completion:@escaping (_ mediaItems: [InstagramMedia]?, _ error: String?) -> Void) {
        let endpoint = InstagramUsersRecentMediaEndpoint.replacingOccurrences(of: "$USERID$", with: userID)
        let url = InstagramBaseURL + endpoint
        networker.makeGetRequest(url: url, params: []) { (result, error) in
            if let result = result as? [String:Any], error ==  nil, let dataArray = result["data"] as? [[String:Any]] {
                let parser = InstagramParser()
                var allMedia = [InstagramMedia]()
                for data in dataArray {
                    if let media = parser.parseMediaDict(dict: data) {
                        allMedia.append(media)
                    } else {
                        print("Media not properly formatted")
                    }
                }
                completion(allMedia, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getLoggedInUserLikedMedia(completion:@escaping (_ userDict: [String:Any]?, _ error: String?) -> Void) {
        let url = InstagramBaseURL + InstagramGetLoggedInUsersLikedMediaEndpoint
        networker.makeGetRequest(url: url, params: []) { (result, error) in
            if let result = result as? [String:Any], error ==  nil {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func searchUsers(query: String, completion:@escaping (_ userDict: [String:Any]?, _ error: String?) -> Void) {
        let url = InstagramBaseURL + InstagramSearchForUsersEndpoint
        let param = InstagramParam(name: "q", value: query)
        networker.makeGetRequest(url: url, params: [param]) { (result, error) in
            if let result = result as? [String:Any], error ==  nil {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
