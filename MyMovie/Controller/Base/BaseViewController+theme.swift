//
//  BaseViewController+theme.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit

extension BaseViewController {
    func configDefaultTheme() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}
