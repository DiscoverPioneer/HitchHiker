//
//  Codable+Helpers.swift
//
//  Created by Phil Scarfi on 11/4/20.
//

import Foundation
import Cache

extension Dictionary where Key == String {
    func decoded<T: Codable>(_ type: T.Type, printError: Bool = true) -> T? {
        return JSONDecoder.quickDecode(self, to: type, printError: printError)
    }
}

extension Array where Element == Dictionary<String,Any> {
    func decoded<T: Codable>(_ type: T.Type, printError: Bool = true) -> [T] {
        var decodedObjects = [T]()
        for dict in self {
            if let obj = dict.decoded(type) {
                decodedObjects.append(obj)
            }
        }
        return decodedObjects
    }
}

extension JSONDecoder {
    static func quickDecode<T: Codable>(_ json: [String: Any], to type: T.Type, printError: Bool = true) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            return try decode(data, to: type)
        } catch let e {
            if printError {
                print("Error Parsing type: \(T.Type.self) json: \(e)")
            }
        }
      return nil
    }
}

extension Encodable {
  func asDictionary() -> [String: Any]? {
    do {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary
    } catch let e {
        print("error convering object to dictionary: \(e)")
    }
    return nil
  }
}

