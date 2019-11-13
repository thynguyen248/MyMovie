//
//  APIEndpoint.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import Moya

enum APIEndpoint {
    case getRecommendations(movieId: Int, page: Int)
    case getGenres
    case getPopular(page: Int)
    case getTopRated(page: Int)
    case getUpcoming(page: Int)
    case getDetails(movieId: Int)
}

extension APIEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    
    var path: String {
        switch self {
        case .getRecommendations(let movieId, _):
            return "/movie/\(movieId)/recommendations"
        case .getGenres:
            return "/genre/movie/list"
        case .getPopular:
            return "/movie/popular"
        case .getTopRated:
            return "/movie/top_rated"
        case .getUpcoming:
            return "/movie/upcoming"
        case .getDetails(let movieId):
            return "/movie/\(movieId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendations, .getGenres, .getPopular, .getTopRated, .getUpcoming, .getDetails:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRecommendations(_, let page), .getPopular(let page), .getTopRated(let page), .getUpcoming(let page):
            return .requestParameters(parameters: ["api_key": APIKey, "page": page], encoding: URLEncoding.default)
        case .getGenres:
            return .requestParameters(parameters: ["api_key": APIKey], encoding: URLEncoding.default)
        case .getDetails:
            return .requestParameters(parameters: ["api_key": APIKey, "append_to_response": "credits,videos,reviews,recommendations"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var APIKey: String {
        return "7a20b718d2507f11dad2d84d6b028fdd"
    }
    
    var baseURLString: String {
        return "https://api.themoviedb.org/3"
    }
    
}
