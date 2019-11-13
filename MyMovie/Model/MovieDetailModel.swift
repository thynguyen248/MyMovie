//
//  MovieDetailModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import Foundation

struct MovieDetailModel: Decodable {
    let movieId: Int?
    let posterPath: String?
    let backDropPath: String?
    let title: String?
    let overview: String?
    let genres: [CategoryModel]?
    let releaseDate: String?
    let rating: Double?
    let credits: CreditResponseModel?
    let videos: VideoResponseModel?
    let reviews: ReviewResponseModel?
    let recommendations: MovieResponseModel?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case title
        case overview
        case genres
        case releaseDate = "release_date"
        case rating = "vote_average"
        case credits
        case videos
        case reviews
        case recommendations
    }
}
