//
//  APIManager.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/6/19.
//

import Moya
import Alamofire
import RxSwift

class APIManager {
    static let shared = APIManager()
    
    let provider = MoyaProvider<APIEndpoint>()
    let disposeBag = DisposeBag()
    
    private init() {}
    
    func request(target: APIEndpoint, successCompletion: @escaping (_ data: Data) -> (), errorCompletion: @escaping (_ error: Error) -> ()) {
        
        _ = provider.rx.request(target).subscribe { (event) in
            switch event {
            case .success(let response):
                successCompletion(response.data)
            case .error(let error):
                errorCompletion(error)
            }
        }
    }
    
    //MARK: - Get movies
    func getMovies(endPoint: APIEndpoint) -> Single<MovieResponseModel> {
        return Single<MovieResponseModel>.create(subscribe: { (single) -> Disposable in
            
            APIManager.shared.request(target: endPoint, successCompletion: { data in
                let decoder = JSONDecoder()
                do {
                    let movieList = try decoder.decode(MovieResponseModel.self, from: data)
                    single(.success(movieList))
                } catch {
                    single(.error(error))
                }
                
            }, errorCompletion: { error in
                single(.error(error))
            })
            
            return Disposables.create()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    //MARK: - Get categories
    func getCategories() -> Single<CategoryResponseModel> {
        return Single<CategoryResponseModel>.create(subscribe: { (single) -> Disposable in
            
            APIManager.shared.request(target: APIEndpoint.getGenres, successCompletion: { data in
                
                let decoder = JSONDecoder()
                do {
                    let categoryResponse = try decoder.decode(CategoryResponseModel.self, from: data)
                    single(.success(categoryResponse))
                } catch {
                    single(.error(error))
                }
                
            }, errorCompletion: { error in
                single(.error(error))
            })
            
            return Disposables.create()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    //MARK: - Get details
    func getDetails(movieId: Int) -> Single<MovieDetailModel> {
        return Single<MovieDetailModel>.create(subscribe: { (single) -> Disposable in
            
            APIManager.shared.request(target: APIEndpoint.getDetails(movieId: movieId), successCompletion: { data in
                
                let decoder = JSONDecoder()
                do {
                    let movieDetail = try decoder.decode(MovieDetailModel.self, from: data)
                    single(.success(movieDetail))
                } catch {
                    single(.error(error))
                }
                
            }, errorCompletion: { error in
                single(.error(error))
            })
            
            return Disposables.create()
        }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
