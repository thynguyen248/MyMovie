//
//  BaseViewController+refreshControl.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import RxSwift
import RxCocoa

extension BaseViewController {
    func addRefresherToList(_ listView: UIScrollView) {
        refresher = UIRefreshControl()
        if #available(iOS 10.0, *) {
            listView.refreshControl = refresher
        } else {
            listView.addSubview(refresher!)
        }
        isRefreshing.bind(to: refresher!.rx.isRefreshing).disposed(by: disposeBag)
    }
}
