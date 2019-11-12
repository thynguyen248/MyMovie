//
//  HorizontalListViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/8/19.
//

import RxSwift
import RxCocoa

struct ItemViewModel {
    let itemId: Int?
    let title: String?
    let subTitle: String?
    let posterPath: String?
    
    var posterUrl: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct HorizontalListViewModel {
    var dataList = [ItemViewModel]()
    var sectionType: HomeSectionType = .Popular
    var pagingInfo: PagingInfoModel?
    var isLoadingMore = PublishSubject<Void>()
}
