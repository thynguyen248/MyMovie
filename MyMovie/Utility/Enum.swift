//
//  Enum.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/9/19.
//

import UIKit

enum SectionType: Int {
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
