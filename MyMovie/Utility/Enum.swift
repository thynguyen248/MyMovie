//
//  Enum.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/9/19.
//

import UIKit

protocol SectionType {
    var description: String { get }
    var itemWidth: CGFloat { get }
    var itemHeight: CGFloat { get }
}

enum HomeSectionType: Int, SectionType {
    case recommendation
    case category
    case popular
    case topRated
    case upcoming
    
    var description: String {
        switch self {
        case .recommendation:
            return "Recommendation"
        case .category:
            return "Category"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top rated"
        case .upcoming:
            return "Upcoming"
        }
    }
    
    var itemHeight: CGFloat {
        switch self {
        case .recommendation:
            return 160.0
        case .category:
            return 80.0
        case .popular, .topRated, .upcoming:
            return 260.0
        }
    }
    
    var itemWidth: CGFloat {
        switch self {
        case .recommendation:
            return 300.0
        case .category:
            return 140.0
        case .popular, .topRated, .upcoming:
            return 140.0
        }
    }
}

enum DetailSectionType: Int, SectionType {
    case media
    case overview
    case favorite
    case rating
    case cast
    case video
    case comment
    case recommendation
    
    var description: String {
        switch self {
        case .media:
            return ""
        case .overview:
            return ""
        case .favorite:
            return ""
        case .rating:
            return "Your Rate"
        case .cast:
            return "Series Cast"
        case .video:
            return "Video"
        case .comment:
            return "Comments"
        case .recommendation:
            return "Recommendations"
        }
    }
    
    var itemHeight: CGFloat {
        switch self {
        case .media:
            return 0
        case .overview:
            return 0
        case .favorite:
            return 0
        case .rating:
            return 185
        case .cast:
            return 144
        case .video:
            return 120
        case .comment:
            return 0
        case .recommendation:
            return 192
        }
    }
    
    var itemWidth: CGFloat {
        switch self {
        case .media:
            return 0
        case .overview:
            return 0
        case .favorite:
            return 0
        case .rating:
            return 0
        case .cast:
            return 70
        case .video:
            return 200
        case .comment:
            return 0
        case .recommendation:
            return 100
        }
    }
}

enum Segue: String {
    case movieToMovieDetail = "movieToMovieDetail"
    case movieDetailToMovieDetail = "movieDetailToMovieDetail"
}
