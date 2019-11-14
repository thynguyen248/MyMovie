//
//  OverviewViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import RxSwift
import RxCocoa

class OverviewViewModel {
    private let title: String?
    private let overview: String?
    private let viewWidth: CGFloat
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 24.0)
    private let overviewFont = UIFont.systemFont(ofSize: 18.0)
    private let overviewMaxLines: CGFloat = 5.0
    private let originalOverviewHeight: CGFloat
    private let titleHeight: CGFloat
    private let maxHeight: CGFloat
    
    var sectionHeight: CGFloat = 0
    var overviewHeight: CGFloat = 0
    var isOverviewFit: Bool = false
    let showFullText = BehaviorRelay<Bool>(value: false)
    
    init(title: String?, overview: String?, viewWidth: CGFloat) {
        self.title = title
        self.overview = overview
        self.viewWidth = viewWidth
        
        maxHeight = ceil(overviewFont.lineHeight * overviewMaxLines)
        titleHeight = (title ?? "").height(withConstrainedWidth: viewWidth, font: titleFont)
        originalOverviewHeight = (overview ?? "").height(withConstrainedWidth: viewWidth, font: overviewFont)
        isOverviewFit = originalOverviewHeight <= maxHeight
        update()
    }
    
    var titleAttributedString: NSAttributedString? {
        guard let title = title else {
            return nil
        }
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: titleFont, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#3E4A59")])
        return attributedString
    }
    
    var overviewAttributedString: NSAttributedString? {
        guard let overview = overview else {
            return nil
        }
        let attributedString = NSAttributedString(string: overview, attributes: [NSAttributedString.Key.font: overviewFont, NSAttributedString.Key.foregroundColor: UIColor(hexString: "#4A4A4A")])
        return attributedString
    }
    
    func update() {
        if showFullText.value {
            overviewHeight = originalOverviewHeight
        } else {
            overviewHeight = min(originalOverviewHeight, maxHeight)
        }
        sectionHeight = overviewHeight + titleHeight + (isOverviewFit ? 0 : 19.0) + 10.0
    }
}
