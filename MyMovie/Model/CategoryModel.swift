//
//  CategoryModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/6/19.
//

import UIKit

struct CategoryResponseModel: Decodable {
    let response: [CategoryModel]
    
    enum CodingKeys: String, CodingKey {
        case response = "genres"
    }
}

struct CategoryModel: Decodable {
    let categoryId: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "id"
        case name = "name"
    }
}
