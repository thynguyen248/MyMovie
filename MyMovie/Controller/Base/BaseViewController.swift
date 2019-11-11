//
//  BaseViewController.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    // Refresher
    var refresher: UIRefreshControl?
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isRefreshing = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
