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
        case DetailSectionType.Video:
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
        
        switch sectionType {
        case HomeSectionType.Recommendation:
            bottomView.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 250)
        case HomeSectionType.Popular, HomeSectionType.TopRated, HomeSectionType.Upcoming:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = false
            imageRatio.priority = UILayoutPriority(rawValue: 999)
        case HomeSectionType.Category:
            bottomView.isHidden = true
            bottomTitleLabel.isHidden = true
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = false
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 250)
        case DetailSectionType.Cast:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = false
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 999)
            imageCornerRadius = 3.0
            titleFont = UIFont.systemFont(ofSize: 12.0)
        case DetailSectionType.Video:
            bottomView.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = false
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 250)
            imageCornerRadius = 12.0
        case DetailSectionType.Recommendation:
            bottomView.isHidden = false
            bottomTitleLabel.isHidden = false
            subTitleLabel.isHidden = true
            centerTitleLabel.isHidden = true
            playButton.isHidden = true
            moreButton.isHidden = true
            imageRatio.priority = UILayoutPriority(rawValue: 999)
        default:
            break
        }
        
        playerView.layer.cornerRadius = imageCornerRadius
        posterImageView.layer.cornerRadius = imageCornerRadius
        bottomTitleLabel.font = titleFont
    }
    
    @IBAction func didTouchPlayButton(_ sender: AnyObject) {
        switch sectionType {
        case DetailSectionType.Video?:
            playerView.playVideo()
        default:
            break
        }
    }
}
