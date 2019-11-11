//
//  MovieModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import Foundation

struct MovieResponseModel: Decodable {
    let pagingInfo: PagingInfoModel
    let movies: [MovieModel]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currentPage = try container.decode(Int.self, forKey: .currentPage)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        pagingInfo = PagingInfoModel(currentPage: currentPage, totalPages: totalPages, hasMoreData: currentPage < totalPages)
        movies = try container.decode([MovieModel].self, forKey: .movies)
    }
}

struct MovieModel: Decodable {
    let imageUrlPath: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrlPath = "poster_path"
        case title = "title"
    }
}
