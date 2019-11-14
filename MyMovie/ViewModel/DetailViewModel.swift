//
//  DetailViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import RxSwift
import RxCocoa

class DetailViewModel {
    let sections = BehaviorRelay<[DetailSectionType]>(value: [])
    
    var movieDetail: MovieDetailModel?
    
    let movieId = PublishSubject<Int>()
    let showFullOverview = PublishSubject<Bool>()
    
    var overviewVM: OverviewViewModel?
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
            self?.movieDetail = detail
            self?.setupOverview(withMovieDetail: detail)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Cast)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Video)
            self?.setupCommentSectionVM(withMovieDetail: detail)
            self?.setupHorizontalSectionVM(withMovieDetail: detail, sectionType: DetailSectionType.Recommendation)
            self?.setupSections(withMovieDetail: detail)
            
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
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
    
    private func setupSections(withMovieDetail detail: MovieDetailModel) {
        var results: [DetailSectionType] = [.Media, .Overview, .Favorite, .Rating]
        if !(detail.credits?.credits ?? []).isEmpty {
            results.append(.Cast)
        }
        if !(detail.videos?.results ?? []).isEmpty {
            results.append(.Video)
        }
        if !(detail.reviews?.results ?? []).isEmpty {
            results.append(.Comment)
        }
        if !(detail.recommendations?.movies ?? []).isEmpty {
            results.append(.Recommendation)
        }
        sections.accept(results)
    }
    
    private func setupOverview(withMovieDetail detail: MovieDetailModel) {
        overviewVM = OverviewViewModel(title: detail.title, overview: detail.overview, viewWidth: UIScreen.main.bounds.size.width - 16.0 - 10.0)
        overviewVM!.showFullText.asDriver().drive(onNext: { [weak self] isFull in
            self?.overviewVM?.update()
            self?.showFullOverview.onNext(isFull)
        }).disposed(by: disposeBag)
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
    
    private func loadMore(sectionType: SectionType) {
        guard let sectionVM = getHorizontalSectionViewModel(withType: sectionType) else {
            return
        }
        
        switch sectionType {
        case DetailSectionType.Recommendation:
            guard let movieId = movieDetail?.movieId else {
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
