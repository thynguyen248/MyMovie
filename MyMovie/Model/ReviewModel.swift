//
//  ReviewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import Foundation

struct ReviewResponseModel: Decodable {
    let pagingInfo: PagingInfoModel?
    let results: [ReviewModel]?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        let totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        pagingInfo = PagingInfoModel(currentPage: currentPage, totalPages: totalPages, hasMoreData: (currentPage ?? 0) < (totalPages ?? 0))
        results = try container.decode([Safe<ReviewModel>].self, forKey: .results).compactMap { $0.value }
    }
}

struct ReviewModel: Decodable {
    let author: String?
    let content: String?
}
