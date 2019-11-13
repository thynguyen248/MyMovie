//
//  DetailViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import RxSwift
import RxCocoa

class DetailViewModel {
    let sections: [DetailSectionType] = [.Media, .Overview, .Favorite, .Rating, .Cast, .Video, .Comment, .Recommendation]
    
    let movieDetail = BehaviorRelay<MovieDetailModel?>(value: nil)
    let movieId = PublishSubject<Int>()
    
    var overviewViewModel: OverviewViewModel?
    var castSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var videoSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    var commentSectionVM = BehaviorRelay<[ReviewModel]?>(value: nil)
    var recommendationSectionVM = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    
    let errorSubject = PublishSubject<Error>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    init() {
        movieId
            .flatMapFirst {
                APIManager.shared.getDetails(movieId: $0)
        }
        .subscribe(onNext: { [weak self] detail in
            
            self?.isLoading.accept(false)
            self?.setupOverview(withMovieDetail: detail)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Cast)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Video)
            self?.setupCommentSectionVM(withMovieDetail: detail)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Recommendation)
            self?.movieDetail.accept(detail)
            
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    private func setupOverview(withMovieDetail detail: MovieDetailModel) {
        overviewViewModel = OverviewViewModel(title: detail.title, overview: detail.overview, viewWidth: UIScreen.main.bounds.size.width - 16.0 - 10.0)
    }
    
    private func setupHorizontalSectionVM(withMovieDetail detail: MovieDetailModel, sectionType: SectionType) {
        
        var sectionVM = HorizontalListViewModel()
        sectionVM.sectionType = sectionType
        
        switch sectionType {
        case DetailSectionType.Cast:
            guard let credits = detail.credits?.credits, !credits.isEmpty else {
                return
            }
            sectionVM.dataList = credits.map { ItemViewModel(itemId: nil, title: $0.title, subTitle: $0.subTitle, posterPath: $0.profileUrlPath) }
            castSectionVM.accept(sectionVM)
        case DetailSectionType.Video:
            guard let videos = detail.videos?.results, !videos.isEmpty else {
                return
            }
            sectionVM.dataList = videos.map { ItemViewModel(itemId: $0.key, title: nil, subTitle: nil, posterPath: nil) }
            videoSectionVM.accept(sectionVM)
        case DetailSectionType.Recommendation:
            guard let movies = detail.recommendations?.movies, !movies.isEmpty else {
                return
            }
            sectionVM.dataList = movies.map { ItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath) }
            sectionVM.pagingInfo = detail.recommendations?.pagingInfo
            
            recommendationSectionVM.accept(sectionVM)
        default:
            break
        }
        
        sectionVM.isLoadingMore.subscribe(onNext: { [weak self] in
            self?.loadMore(sectionType: sectionType)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    private func setupCommentSectionVM(withMovieDetail detail: MovieDetailModel) {
        guard let comments = detail.reviews?.results, !comments.isEmpty else {
            return
        }
        commentSectionVM.accept(comments)
    }
    
    func getHorizontalSectionViewModel(withType sectionType: SectionType) -> HorizontalListViewModel? {
        switch sectionType {
        case DetailSectionType.Cast:
            return castSectionVM.value
        case DetailSectionType.Video:
            return videoSectionVM.value
        case DetailSectionType.Recommendation:
            return recommendationSectionVM.value
        default:
            return nil
        }
    }
    
    func loadMore(sectionType: SectionType) {
        guard let sectionVM = getHorizontalSectionViewModel(withType: sectionType) else {
            return
        }
        
        switch sectionType {
        case DetailSectionType.Recommendation:
            guard let movieId = movieDetail.value?.movieId else {
                return
            }
            let endpoint = APIEndpoint.getRecommendations(movieId: movieId, page: (sectionVM.pagingInfo?.currentPage ?? 0) + 1)
            APIManager.shared.getMovies(endPoint: endpoint).subscribe(onSuccess: { [weak self] movieResponse in
                guard let movies = movieResponse.movies, !movies.isEmpty else {
                    return
                }
                var updatedVM = HorizontalListViewModel()
                updatedVM.dataList = sectionVM.dataList + movies.map { ItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath) }
                updatedVM.pagingInfo = sectionVM.pagingInfo
                updatedVM.sectionType = sectionType
                self?.recommendationSectionVM.accept(updatedVM)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
                }).disposed(by: disposeBag)
        default:
            break
        }
    }
}
