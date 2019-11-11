//
//  Error.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/9/19.
//

import Foundation

enum DefaultError: Error {
    case unknown
}

extension DefaultError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown: return NSLocalizedString("An unknown error occurred.", comment: "")
        }
    }
}
