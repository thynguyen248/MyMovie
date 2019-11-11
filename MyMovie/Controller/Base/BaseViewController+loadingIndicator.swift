//
//  BaseViewController+loadingIndicator.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit

extension BaseViewController {
    func bindLoadingIndicator(_ loadingIndicator: UIActivityIndicatorView) {
        isLoading.asDriver().drive(loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
    }
}
