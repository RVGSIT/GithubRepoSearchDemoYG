//
//  String+Extension.swift
//  githubsearch
//
//  Created by Rachit Vyas on 10/18/21.
//  Copyright © 2021 Globalsys. All rights reserved.
//

import Foundation

extension String {
    static func concatStrings(_ strings: [String?], separatedBy separator: String) -> String {
        let returnString = strings.reduce("") { (result, nextString) in
            guard let string = nextString else { return result + "" }
            if result.isEmpty {
                return result + String(format: "%@", string)
            }
            return result + String(format: "%@%@", separator, string)
        }

        return returnString
    }
}
