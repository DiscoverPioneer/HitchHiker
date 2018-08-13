//
//  InstagramNetworker.swift
//  InstaVault
//
//  Created by Phil Scarfi on 8/9/17.
//  Copyright © 2017 Pioneer Mobile Applications. All rights reserved.
//

import Foundation

public class InstagramNetworker {
    let accessToken: String
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    public func makeGetRequest(url: String, params: [InstagramParam], completion:@escaping (_ response: Any?, _ error: String?) -> Void) {
        
        guard let urlComponents = NSURLComponents(string: url) else {
            completion(nil, "Not a valid url")
            return
        }
        var queryItems = [URLQueryItem]()
        let accessParam = URLQueryItem(name: "access_token", value: self.accessToken)
        queryItems.append(accessParam)
        for param in params {
            let item = URLQueryItem(name: param.name, value: param.value)
            queryItems.append(item)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, "Invalid URL Components")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completion(nil, "Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            completion(json, error?.localizedDescription)
        }
        
        task.resume()
    }
}

public struct InstagramParam {
    let name: String
    let value: String?
}
