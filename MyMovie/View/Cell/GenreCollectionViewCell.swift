//
//  GenreCollectionViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell, ReusableView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        borderView.layer.cornerRadius = 8.0
    }

}
