//
//  MovieDetailModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import Foundation

struct MovieDetailModel: Decodable {
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
    
    var posterUrl: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backDropUrl: URL? {
        guard let backDropPath = backDropPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backDropPath)")
    }
}
