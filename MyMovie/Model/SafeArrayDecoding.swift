//
//  SafeArrayDecoding.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import Foundation

struct Safe<Base: Decodable>: Decodable {
    public let value: Base?
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }
}
