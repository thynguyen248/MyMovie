//
//  DetailPosterTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper
import Cosmos

class MediaTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var starValueLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    private var movieDetail: MovieDetailModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        posterImageView.layer.cornerRadius = 6.0
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        genreCollectionView.register(GenreCollectionViewCell.nib, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(withMovieDetail detail: MovieDetailModel) {
        movieDetail = detail
        posterImageView.kf.setImage(with: detail.posterUrl)
        if let videos = detail.videos?.results, let key = videos.first?.key {
            playerView.load(withVideoId: key)
        }
        starValueLabel.text = "\(detail.rating ?? 0.0)"
        starView.rating = (detail.rating ?? 0.0) / 2.0
        datetimeLabel.text = detail.releaseDate
        genreCollectionView.reloadData()
    }
    
    @IBAction func didTouchPlayButton(_ sender: AnyObject) {
        playerView.playVideo()
    }
}

extension MediaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (movieDetail.genres ?? []).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        let genre = movieDetail.genres![indexPath.item]
        cell.nameLabel.text = genre.name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let name = movieDetail.genres![indexPath.item].name else {
            return CGSize.zero
        }
        return CGSize(width: name.width(withConstrainedHeight: .greatestFiniteMagnitude, font: UIFont.systemFont(ofSize: 12.0)) + 20.0, height: 21.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
