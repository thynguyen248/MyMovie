//
//  CommentTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/13/19.
//

import UIKit
import Kingfisher
import Cosmos

class CommentTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.height / 2.0
        ratingLabel.text = "\(starView.rating)"
    }

    func config(withReview review: ReviewModel, showSeparator: Bool = false) {
        nameLabel.text = review.author
        contentLabel.text = review.content
        separator.isHidden = !showSeparator
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
