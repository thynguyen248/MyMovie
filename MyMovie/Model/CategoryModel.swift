//
//  CategoryModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/6/19.
//

import UIKit

struct CategoryResponseModel: Decodable {
    let genres: [CategoryModel]?
    
    enum CodingKeys: String, CodingKey {
        case genres
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        genres = try container.decodeIfPresent([Safe<CategoryModel>].self, forKey: .genres)?.compactMap { $0.value }
    }
}

struct CategoryModel: Decodable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
