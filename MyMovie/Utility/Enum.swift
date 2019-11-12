//
//  Enum.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/9/19.
//

import UIKit

enum HomeSectionType: Int {
    case Recommendation
    case Category
    case Popular
    case TopRated
    case Upcoming
    
    var description: String {
        switch self {
        case .Recommendation:
            return "Recommendation"
        case .Category:
            return "Category"
        case .Popular:
            return "Popular"
        case .TopRated:
            return "Top rated"
        case .Upcoming:
            return "Upcoming"
        }
    }
    
    var itemHeight: CGFloat {
        switch self {
        case .Recommendation:
            return 160.0
        case .Category:
            return 80.0
        case .Popular, .TopRated, .Upcoming:
            return 260.0
        }
    }
    
    var itemWidth: CGFloat {
        switch self {
        case .Recommendation:
            return 300.0
        case .Category:
            return 140.0
        case .Popular, .TopRated, .Upcoming:
            return 140.0
        }
    }
}

enum DetailSectionType: Int {
    case Media
    case Content
    case Favorite
    case Rating
    case Cast
    case Video
    case Comment
    case Recommendation
    
    var description: String {
        switch self {
        case .Media:
            return ""
        case .Content:
            return ""
        case .Favorite:
            return ""
        case .Rating:
            return "Your Rate"
        case .Cast:
            return "Series Cast"
        case .Video:
            return "Video"
        case .Comment:
            return "Comments"
        case .Recommendation:
            return "Recommendations"
        }
    }
    
    var itemHeight: CGFloat {
        switch self {
        case .Media:
            return 0
        case .Content:
            return 0
        case .Favorite:
            return 0
        case .Rating:
            return 185
        case .Cast:
            return 198
        case .Video:
            return 180
        case .Comment:
            return 0
        case .Recommendation:
            return 250
        }
    }
    
    var itemWidth: CGFloat {
        switch self {
        case .Media:
            return 0
        case .Content:
            return 0
        case .Favorite:
            return 0
        case .Rating:
            return 0
        case .Cast:
            return 70
        case .Video:
            return 200
        case .Comment:
            return 0
        case .Recommendation:
            return 100
        }
    }
}

enum Segue: String {
    case movieToMovieDetail = "movieToMovieDetail"
}
