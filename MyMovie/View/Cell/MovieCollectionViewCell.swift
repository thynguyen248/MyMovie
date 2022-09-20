//
//  MovieCollectionViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/7/19.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper

class MovieCollectionViewCell: UICollectionViewCell, ReusableView {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var imageRatio: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var sectionType: SectionType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        posterImageView.clipsToBounds = true
    }

    func configWithDisplayViewModel(displayItem: ItemViewModel, sectionType: SectionType) {
        self.sectionType = sectionType
        var imageUrl: URL?
        switch sectionType {
        case DetailSectionType.video:
            if let key = displayItem.itemId as? String {
                imageUrl = key.videoThumbnailUrl
                playerView.load(withVideoId: key)
            }
        default:
            if let posterPath = displayItem.posterPath {
                imageUrl = posterPath.posterUrl
            }
        }
        posterImageView.kf.setImage(with: imageUrl)
        bottomTitleLabel.text = displayItem.title
        centerTitleLabel.text = displayItem.title
        subTitleLabel.text = displayItem.subTitle
        updateUI(withSectionType: sectionType)
    }
    
    private func updateUI(withSectionType sectionType: SectionType) {
        var titleFont = UIFont.boldSystemFont(ofSize: 15.0)
        var imageCornerRadius: CGFloat = 6.0
        var keepImageRatio = false
        var titleMaxLines = 2
        
        switch sectionType {
        case HomeSectionType.recommendation:
            bottomView.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
        case HomeSectionType.popular, HomeSectionType.topRated, HomeSectionType.upcoming, DetailSectionType.recommendation:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = false
            keepImageRatio = true
        case HomeSectionType.category:
            bottomView.isHidden = true
            bottomTitleLabel.isHidden = true
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = false
            playButton.isHidden = true
            moreButton.isHidden = true
        case DetailSectionType.cast:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = false
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
            keepImageRatio = true
            imageCornerRadius = 3.0
            titleFont = UIFont.systemFont(ofSize: 12.0)
            titleMaxLines = 1
        case DetailSectionType.video:
            bottomView.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = false
            moreButton.isHidden = true
            imageCornerRadius = 12.0
        default:
            break
        }
        
        if keepImageRatio {
            imageRatio.priority = UILayoutPriority(rawValue: 999)
            bottomConstraint.priority = UILayoutPriority(rawValue: 250)
        } else {
            imageRatio.priority = UILayoutPriority(rawValue: 250)
            bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        playerView.layer.cornerRadius = imageCornerRadius
        posterImageView.layer.cornerRadius = imageCornerRadius
        bottomTitleLabel.font = titleFont
        bottomTitleLabel.numberOfLines = titleMaxLines
    }
    
    @IBAction func didTouchPlayButton(_ sender: AnyObject) {
        switch sectionType {
        case DetailSectionType.video?:
            playerView.playVideo()
        default:
            break
        }
    }
}
