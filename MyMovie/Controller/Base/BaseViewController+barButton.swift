//
//  BaseViewController+barButton.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit

extension BaseViewController {
    func addLeftBarButtonWithImage(_ buttonImage: UIImage) {
        let leftButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(toggleLeft))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func toggleLeft() {}
    
    func addRightBarButtonWithImage(_ buttonImage: UIImage) {
        let rightButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(toggleRight))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func toggleRight() {}
}
