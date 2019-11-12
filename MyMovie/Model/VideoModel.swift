//
//  VideoModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import Foundation

struct VideoResponseModel: Decodable {
    let results: [VideoModel]?
}

struct VideoModel: Decodable {
    let key: String?
}
