//
//  MovieCollectionViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/7/19.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell, ReusableView {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var imageRatio: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        posterImageView.layer.cornerRadius = 6.0
        posterImageView.clipsToBounds = true
    }

    func configWithDisplayViewModel(displayItem: ItemDisplayViewModel, sectionType: SectionType) {
        posterImageView.kf.setImage(with: displayItem.imageUrl)
        bottomTitleLabel.text = displayItem.title
        centerTitleLabel.text = displayItem.title
        subTitleLabel.text = displayItem.subTitle
        updateUI(withSectionType: sectionType)
    }
    
    func updateUI(withSectionType sectionType: SectionType) {
        switch sectionType {
        case .Recommendation:
            bottomView.isHidden = true
            bottomTitleLabel.isHidden = true
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 250)
        case .Popular, .TopRated, .Upcoming:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = false
            imageRatio.priority = UILayoutPriority(rawValue: 999)
//        case .Upcoming:
//            bottomView.isHidden = false
//            bottomTitleLabel.isHidden = false
//            subTitleLabel.isHidden = true
//            centerTitleLabel.isHidden = true
//            playButton.isHidden = true
//            moreButton.isHidden = false
//            imageRatio.priority = UILayoutPriority(rawValue: 999)
        case .Category:
            bottomView.isHidden = true
            bottomTitleLabel.isHidden = true
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = false
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 250)
        }
    }
}
