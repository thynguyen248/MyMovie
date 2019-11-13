//
//  BaseViewController+barButton.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit

extension BaseViewController {
    func addLeftBarButton(withImage image: UIImage) {
        let leftButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleLeft))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func toggleLeft() {}
    
    func addRightBarButton(withImage image: UIImage) {
        let rightButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleRight))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func toggleRight() {}
}
