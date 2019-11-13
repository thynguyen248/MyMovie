//
//  RatingTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        starView.settings.fillMode = .precise
        starView.didTouchCosmos = { [weak self] rating in
            self?.ratingLabel.textColor = rating > 0.0 ? UIColor(hexString: "#F1CA23") : UIColor(hexString: "#9B9B9B")
            self?.ratingLabel.text = "\(String(format: "%.1f", rating))"
        }
        commentButton.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTouchCommentButton(_ sender: AnyObject) {
        
    }
}
