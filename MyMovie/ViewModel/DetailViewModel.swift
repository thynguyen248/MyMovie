//
//  DetailViewModel.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import RxSwift
import RxCocoa

class DetailViewModel {
    let sections: [DetailSectionType] = [.Media, .Content, .Favorite, .Rating, .Cast, .Video, .Comment, .Recommendation]
    let movieDetail = BehaviorRelay<MovieDetailModel?>(value: nil)
    let movieId = PublishSubject<Int>()
    
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
            self?.movieDetail.accept(detail)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    
}
