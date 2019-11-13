//
//  HorizontalListViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/8/19.
//

import RxSwift
import RxCocoa

struct ItemViewModel {
    let itemId: Any?
    let title: String?
    let subTitle: String?
    let posterPath: String?
}

struct HorizontalListViewModel {
    var dataList = [ItemViewModel]()
    var sectionType: SectionType = HomeSectionType.Popular
    var pagingInfo: PagingInfoModel?
    var isLoadingMore = PublishSubject<Void>()
}
