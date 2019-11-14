//
//  MovieModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import Foundation

struct MovieResponseModel: Decodable {
    let pagingInfo: PagingInfoModel?
    let movies: [MovieModel]?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        let totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        pagingInfo = PagingInfoModel(currentPage: currentPage, totalPages: totalPages, hasMoreData: (currentPage ?? 0) < (totalPages ?? 0))
        movies = try container.decodeIfPresent([Safe<MovieModel>].self, forKey: .movies)?.compactMap { $0.value }
    }
}

struct MovieModel: Decodable {
    let movieId: Int?
    let posterPath: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case posterPath = "poster_path"
        case title = "title"
    }
}
