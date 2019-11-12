//
//  CategoryModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/6/19.
//

import UIKit

struct CategoryResponseModel: Decodable {
    let genres: [CategoryModel]?
}

struct CategoryModel: Decodable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
