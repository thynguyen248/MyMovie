//
//  FavoriteTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchAddButton(_ sender: AnyObject) {
        
    }
}
