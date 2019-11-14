//
//  OverviewTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import UIKit

class OverviewTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var overviewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: OverviewViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(withOverviewVM viewModel: OverviewViewModel?) {
        self.viewModel = viewModel
        guard let vm = viewModel else {
            return
        }
        titleLabel.attributedText = vm.titleAttributedString
        overviewLabel.attributedText = vm.overviewAttributedString
        overviewHeightConstraint.constant = vm.overviewHeight
        actionButton.isHidden = vm.isOverviewFit
        if vm.showFullText.value {
            actionButton.setTitle("Show less", for: .normal)
        } else {
            actionButton.setTitle("Read more", for: .normal)
        }
    }
    
    @IBAction func didTouchActionButton(_ sender: AnyObject) {
        let currentStatus = viewModel?.showFullText.value ?? false
        viewModel?.showFullText.accept(!currentStatus)
    }
}
