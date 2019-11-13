//
//  String+date.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/13/19.
//

import Foundation

extension String {
    func getShortDateFormat() -> String? {
        let sourceDateFormatter = DateFormatter()
        sourceDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let sourceDate = sourceDateFormatter.date(from: self) else {
            return nil
        }
        let targetFormatter = DateFormatter()
        targetFormatter.dateFormat = "MMMM yyyy"
        return targetFormatter.string(from: sourceDate)
    }
}
