//
//  OverviewTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/12/19.
//

import RxSwift
import RxCocoa

class OverviewTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var overviewHeightConstraint: NSLayoutConstraint!
    
    let viewModel = BehaviorRelay<OverviewViewModel?>(value: nil)
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewModel.asDriver().drive(onNext: { [weak self] _ in
            self?.configUI()
        }).disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configUI() {
        guard let vm = viewModel.value else {
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
        let currentStatus = viewModel.value?.showFullText.value ?? false
        viewModel.value?.showFullText.accept(!currentStatus)
    }
}
