//
//  HorizontalListTableViewCell.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/7/19.
//

import RxSwift
import RxCocoa

class HorizontalListTableViewCell: UITableViewCell, ReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = BehaviorRelay<HorizontalListViewModel?>(value: nil)
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCollectionView()
        setupViewModel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCollectionView() {
        collectionView.register(MovieCollectionViewCell.nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    private func setupViewModel() {
        viewModel.asDriver(onErrorJustReturn: nil).drive(onNext: { [weak self] vm in
            guard let strongSelf = self else {
                return
            }
            let updatedNumberOfItems = vm?.dataList.count ?? 0
            let currentNumberOfItems = strongSelf.collectionView.numberOfItems(inSection: 0)
            
            if currentNumberOfItems < updatedNumberOfItems {
                let indexPaths = Array(currentNumberOfItems ..< updatedNumberOfItems).map { IndexPath(item: $0, section: 0) }
                
                strongSelf.collectionView.performBatchUpdates({
                    strongSelf.collectionView.insertItems(at: indexPaths)
                }, completion: nil)
            } else {
                strongSelf.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        collectionView.reloadData()
    }
}

extension HorizontalListTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.value?.dataList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        let displayViewModel = viewModel.value!.dataList[indexPath.item]
        cell.configWithDisplayViewModel(displayItem: displayViewModel, sectionType: viewModel.value!.sectionType)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.value!.dataList.count - 1, viewModel.value?.pagingInfo?.hasMoreData == true {
            viewModel.value!.isLoadingMore.accept(viewModel.value?.sectionType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewModel.value!.sectionType.itemWidth, height: viewModel.value!.sectionType.itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
