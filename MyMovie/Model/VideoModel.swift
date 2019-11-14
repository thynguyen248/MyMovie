//
//  VideoModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import Foundation

struct VideoResponseModel: Decodable {
    let results: [VideoModel]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decodeIfPresent([Safe<VideoModel>].self, forKey: .results)?.compactMap { $0.value }
    }
}

struct VideoModel: Decodable {
    let key: String?
}
