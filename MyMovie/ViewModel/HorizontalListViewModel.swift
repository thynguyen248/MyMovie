//
//  HorizontalListViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/8/19.
//

import RxSwift
import RxCocoa

struct ItemDisplayViewModel {
    let title: String?
    let subTitle: String?
    let imageUrlPath: String?
    
    var imageUrl: URL? {
        guard let imageUrlPath = imageUrlPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlPath)")
    }
}

struct HorizontalListViewModel {
    var dataList = [ItemDisplayViewModel]()
    var sectionType: SectionType = .Popular
    var pagingInfo: PagingInfoModel?
    var isLoadingMore = BehaviorRelay<SectionType?>(value: nil)
}
