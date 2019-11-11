//
//  BaseViewController+alert.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit

extension BaseViewController {
    func showAlerWithMessage(_ message: String, _ completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            completion?()
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
