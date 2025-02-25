//
//  Dictionary+Extension.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/22/25.
//

import Foundation

extension Dictionary {
    var toArray: [Value] {
        self.map({ $0.value })
    }
}
