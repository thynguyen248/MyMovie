//
//  HomeViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import RxSwift
import RxCocoa

class HomeViewModel {
    var sections: [HomeSectionType] = [.recommendation, .category, .popular, .topRated, .upcoming]
    
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
    
    func loadData() {
        loadMovieList(type: HomeSectionType.recommendation)
        loadCategoryList()
        loadMovieList(type: HomeSectionType.popular)
        loadMovieList(type: HomeSectionType.topRated)
        loadMovieList(type: HomeSectionType.upcoming)
    }
    
    func getSectionViewModel(withType sectionType: SectionType) -> HorizontalListViewModel? {
        switch sectionType {
        case HomeSectionType.recommendation:
            return recommendationSectionVM.value
        case HomeSectionType.category:
            return categorySectionVM.value
        case HomeSectionType.popular:
            return popularSectionVM.value
        case HomeSectionType.topRated:
            return topRatedSectionVM.value
        case HomeSectionType.upcoming:
            return upcomingSectionVM.value
        default:
            return nil
        }
    }
    
    private func loadMovieList(type: SectionType, movieId: Int? = nil, currentPage: Int? = nil) {
        var endpoint: APIEndpoint?
        
        let targetPagingInfo = getSectionViewModel(withType: type)?.pagingInfo
        let targetPage = (currentPage ?? targetPagingInfo?.currentPage ?? 0) + 1
        
        switch type {
        case HomeSectionType.recommendation:
            // Hard code
            let targetId = movieId ?? 278
            endpoint = APIEndpoint.getRecommendations(movieId: targetId, page: targetPage)
        case HomeSectionType.popular:
            endpoint = APIEndpoint.getPopular(page: targetPage)
        case HomeSectionType.topRated:
            endpoint = APIEndpoint.getTopRated(page: targetPage)
        case HomeSectionType.upcoming:
            endpoint = APIEndpoint.getUpcoming(page: targetPage)
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
            case HomeSectionType.recommendation:
                sectionVM.dataList = (self?.recommendationSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.recommendationSectionVM.accept(sectionVM)
                
            case HomeSectionType.popular:
                sectionVM.dataList = (self?.popularSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.popularSectionVM.accept(sectionVM)
                
            case HomeSectionType.topRated:
                sectionVM.dataList = (self?.topRatedSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.topRatedSectionVM.accept(sectionVM)
                
            case HomeSectionType.upcoming:
                sectionVM.dataList = (self?.upcomingSectionVM.value?.dataList ?? []) + displayVMs
                sectionVM.pagingInfo = response.pagingInfo
                self?.upcomingSectionVM.accept(sectionVM)
                
            default:
                break
            }
            
            sectionVM.isLoadingMore.subscribe(onNext: {
                self?.loadMovieList(type: type)
            }, onError: { error in
                self?.errorSubject.onNext(error)
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    private func loadCategoryList() {
        APIManager.shared.getCategories()
            .subscribe(onSuccess: { [weak self] categoryResponse in
                
                guard let genres = categoryResponse.genres, !genres.isEmpty else {
                    return
                }
                
                let displayVMs = genres.map { ItemViewModel(itemId: nil, title: $0.name, subTitle: nil, posterPath: nil) }
                var sectionVM = HorizontalListViewModel()
                sectionVM.sectionType = HomeSectionType.category
                sectionVM.dataList = displayVMs
                self?.categorySectionVM.accept(sectionVM)
                
        }, onError: { [weak self] error in
            self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
}
