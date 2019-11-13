//
//  String+URL.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/13/19.
//

import Foundation

extension String {
    var posterUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/original/\(self)")
    }
    
    var videoThumbnailUrl: URL? {
        return URL(string: "https://img.youtube.com/vi/\(self)/hqdefault.jpg")
    }
}
