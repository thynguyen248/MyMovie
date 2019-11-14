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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movieId = try container.decodeIfPresent(Int.self, forKey: .movieId)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        backDropPath = try container.decodeIfPresent(String.self, forKey: .backDropPath)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        genres = try container.decodeIfPresent([Safe<CategoryModel>].self, forKey: .genres)?.compactMap { $0.value }
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        credits = try container.decodeIfPresent(CreditResponseModel.self, forKey: .credits)
        videos = try container.decodeIfPresent(VideoResponseModel.self, forKey: .videos)
        reviews = try container.decodeIfPresent(ReviewResponseModel.self, forKey: .reviews)
        recommendations = try container.decodeIfPresent(MovieResponseModel.self, forKey: .recommendations)
    }
}
