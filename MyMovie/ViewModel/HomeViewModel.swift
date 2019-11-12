//
//  HomeViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import RxSwift
import RxCocoa

class HomeViewModel {
    var sections: [HomeSectionType] = [.Recommendation, .Category, .Popular, .TopRated, .Upcoming]
    
    var recommendationSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var categorySectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var popularSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var topRatedSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var upcomingSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    
    let errorSubject = PublishSubject<Error>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init() {
        Observable.combineLatest(recommendationSectionVM, categorySectionVM, popularSectionVM, topRatedSectionVM, upcomingSectionVM).subscribe(onNext: { [weak self] vm1, vm2, vm3, vm4, vm5 in
            if vm1 != nil && vm2 != nil && vm3 != nil && vm5 != nil {
                self?.isLoading.accept(false)
            }
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func getSectionViewModel(withType sectionType: HomeSectionType) -> HorizontalListViewModel? {
        switch sectionType {
        case .Recommendation:
            return recommendationSectionVM.value
        case .Category:
            return categorySectionVM.value
        case .Popular:
            return popularSectionVM.value
        case .TopRated:
            return topRatedSectionVM.value
        case .Upcoming:
            return upcomingSectionVM.value
        }
    }
    
    func loadMovieList(type: HomeSectionType) {
        var page = 0
        var endpoint: APIEndpoint?
        switch type {
        case .Recommendation:
            page = (recommendationSectionVM.value?.pagingInfo?.currentPage ?? 0) + 1
            // Hard code
            let movieId = 278
            endpoint = APIEndpoint.getRecommendations(movieId: movieId, page: page)
        case .Popular:
            page = (popularSectionVM.value?.pagingInfo?.currentPage ?? 0) + 1
            endpoint = APIEndpoint.getPopular(page: page)
        case .TopRated:
            page = (topRatedSectionVM.value?.pagingInfo?.currentPage ?? 0) + 1
            endpoint = APIEndpoint.getTopRated(page: page)
        case .Upcoming:
            page = (upcomingSectionVM.value?.pagingInfo?.currentPage ?? 0) + 1
            endpoint = APIEndpoint.getUpcoming(page: page)
        default:
            break
        }
        
        APIManager.shared.getMovies(endPoint: endpoint!).subscribe(onSuccess: { [weak self] response in
            
            guard let movies = response.movies, !movies.isEmpty else {
                return
            }
            
            let displayVMs = movies.map { ItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath) }
            var sectionVM = HorizontalListViewModel()
            sectionVM.sectionType = type
            
            switch type {
            case .Recommendation:
                sectionVM.dataList = (self?.recommendationSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.recommendationSectionVM.accept(sectionVM)
                
            case .Popular:
                sectionVM.dataList = (self?.popularSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.popularSectionVM.accept(sectionVM)
                
            case .TopRated:
                sectionVM.dataList = (self?.topRatedSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.topRatedSectionVM.accept(sectionVM)
                
            case .Upcoming:
                sectionVM.dataList = (self?.upcomingSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.upcomingSectionVM.accept(sectionVM)
                
            default:
                break
            }
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func loadCategoryList() {
        APIManager.shared.getCategories()
            .subscribe(onSuccess: { [weak self] categoryResponse in
                
                guard let genres = categoryResponse.genres, !genres.isEmpty else {
                    return
                }
                
                let displayVMs = genres.map { ItemViewModel(itemId: nil, title: $0.name, subTitle: nil, posterPath: nil) }
                var sectionVM = HorizontalListViewModel()
                sectionVM.sectionType = .Category
                sectionVM.dataList = displayVMs
                self?.categorySectionVM.accept(sectionVM)
                
        }, onError: { [weak self] error in
            self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func loadData() {
        loadMovieList(type: .Recommendation)
        loadCategoryList()
        loadMovieList(type: .Popular)
        loadMovieList(type: .TopRated)
        loadMovieList(type: .Upcoming)
    }
    
    func reset() {
        recommendationSectionVM.accept(nil)
        categorySectionVM.accept(nil)
        popularSectionVM.accept(nil)
        topRatedSectionVM.accept(nil)
        upcomingSectionVM.accept(nil)
    }
}
