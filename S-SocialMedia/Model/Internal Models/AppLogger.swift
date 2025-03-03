//
//  AppLogger.swift
//  S-SocialMedia
//
//  Created by Isaque da Silva on 2/25/25.
//

import Foundation
import os.log

struct AppLogger: Sendable {
    private let logger: Logger
    
    func info(_ message: String) {
        logger.info("\(message)")
    }
    
    func error(_ description: String) {
        logger.error("\(description)")
    }
    
    init(category: String) {
        self.logger = .init(
            subsystem: "com.isaqueDaSilva.S-SocialMedia",
            category: category
        )
    }
}
