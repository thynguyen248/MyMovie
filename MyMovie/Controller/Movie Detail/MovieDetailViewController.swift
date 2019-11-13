//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import RxSwift
import RxCocoa
import AVKit

class MovieDetailViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieId: Int!
    private let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupViewModel()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupViewModel() {
        // Loading indicator
        viewModel.isLoading.bind(to: isLoading).disposed(by: disposeBag)
        viewModel.isLoading.bind(to: isRefreshing).disposed(by: disposeBag)
        
        viewModel.movieDetail.asDriver(onErrorJustReturn: nil).drive(onNext: { [weak self] movieDetail in
            self?.tableView.reloadData()
            
            guard let overviewVM = self?.viewModel.overviewViewModel else {
                return
            }
            overviewVM.showFullText.asDriver().drive(onNext: { [weak self] _ in
                if let sectionIndex = self?.viewModel.sections.firstIndex(where: { $0 == .Overview }) {
                    overviewVM.update()
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: sectionIndex)], with: .automatic)
                }
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            
        }).disposed(by: disposeBag)
        
        viewModel.recommendationSectionVM.asDriver().drive(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        // Handle error
        viewModel.errorSubject.asDriver(onErrorJustReturn: DefaultError.unknown).drive(onNext: { [weak self] error in
            self?.showAlerWithMessage(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    // MARK: UI functions
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
    }
    
    private func setupNavigationBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupTableView() {
        tableView.register(MediaTableViewCell.nib, forCellReuseIdentifier: MediaTableViewCell.identifier)
        tableView.register(OverviewTableViewCell.nib, forCellReuseIdentifier: OverviewTableViewCell.identifier)
        tableView.register(FavoriteTableViewCell.nib, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        tableView.register(RatingTableViewCell.nib, forCellReuseIdentifier: RatingTableViewCell.identifier)
        tableView.register(HorizontalListTableViewCell.nib, forCellReuseIdentifier: HorizontalListTableViewCell.identifier)
        tableView.register(CommentTableViewCell.nib, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.register(TitleHeaderView.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifier)
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30.0, right: 0)
    }
    
    private func setupRefreshControl() {
        addRefresherToList(tableView)
        refresher!.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        reloadData()
    }
    
    // MARK: Data loading
    private func loadData() {
        isLoading.accept(true)
        viewModel.movieId.onNext(movieId)
    }
    
    private func reloadData() {
        isRefreshing.accept(true)
        viewModel.movieId.onNext(movieId)
    }
    
    // MARK: Actions
    @IBAction func didTouchBack(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.movieDetailToMovieDetail.rawValue {
            guard let movieId = sender as? Int, let detailVC = segue.destination as? MovieDetailViewController else {
                return
            }
            detailVC.movieId = movieId
        }
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = viewModel.movieDetail.value else {
            return 0
        }
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .Media, .Overview, .Favorite, .Rating:
            return 1
        case .Comment:
            return (viewModel.commentSectionVM.value ?? []).count
        default:
            let sectionVM = viewModel.getHorizontalSectionViewModel(withType: sectionType)
            guard !(sectionVM?.dataList ?? []).isEmpty else {
                return 0
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .Media:
            let videoHeight = UIScreen.main.bounds.size.width * 9 / 16
            return videoHeight + 109.0 + 16.0
        case .Overview:
            return viewModel.overviewViewModel?.sectionHeight ?? .leastNormalMagnitude
        case .Favorite:
            return 110.0
        case .Rating:
            return 175.0
        case .Cast:
            return (viewModel.castSectionVM.value?.dataList ?? []).isEmpty ? .leastNormalMagnitude : sectionType.itemHeight + 39.0
        case .Video:
            return (viewModel.videoSectionVM.value?.dataList ?? []).isEmpty ? .leastNormalMagnitude : sectionType.itemHeight + 45.0
        case .Comment:
            return (viewModel.commentSectionVM.value ?? []).isEmpty ? .leastNormalMagnitude : 129.0
        case .Recommendation:
            return (viewModel.recommendationSectionVM.value?.dataList ?? []).isEmpty ? .leastNormalMagnitude : sectionType.itemHeight + 30.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .Comment:
            guard !(viewModel.commentSectionVM.value ?? []).isEmpty else {
                return .leastNormalMagnitude
            }
            break
        default:
            let sectionVM = viewModel.getHorizontalSectionViewModel(withType: sectionType)
            guard !(sectionVM?.dataList ?? []).isEmpty else {
                return .leastNormalMagnitude
            }
            break
        }
        
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .Comment:
            guard !(viewModel.commentSectionVM.value ?? []).isEmpty else {
                return nil
            }
            break
        default:
            let sectionVM = viewModel.getHorizontalSectionViewModel(withType: sectionType)
            guard !(sectionVM?.dataList ?? []).isEmpty else {
                return nil
            }
            break
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.identifier) as! TitleHeaderView
        headerView.titleLabel.text = sectionType.description
        headerView.bgView.backgroundColor = UIColor(hexString: "#F8F8F8")
        headerView.rightButton.isHidden = true
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .Media:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier, for: indexPath) as? MediaTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            
            cell.selectionStyle = .none
            guard let detail = viewModel.movieDetail.value else {
                return cell
            }
            cell.config(withMovieDetail: detail)
            
            return cell
        case .Overview:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as? OverviewTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            
            cell.selectionStyle = .none
            cell.viewModel.accept(viewModel.overviewViewModel)
            
            return cell
        case .Favorite:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            
            cell.selectionStyle = .none
            
            return cell
        case .Rating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingTableViewCell.identifier, for: indexPath) as? RatingTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            
            cell.selectionStyle = .none
            
            return cell
        case .Cast, .Video, .Recommendation:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalListTableViewCell.identifier, for: indexPath) as? HorizontalListTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            cell.selectionStyle = .none
            guard let sectionVM = viewModel.getHorizontalSectionViewModel(withType: sectionType) else {
                return cell
            }
            
            cell.viewModel.accept(sectionVM)
            cell.didSelectId = { [weak self] selectedId in
                self?.performSegue(withIdentifier: Segue.movieDetailToMovieDetail.rawValue, sender: selectedId)
            }
            
            return cell
        case .Comment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
                fatalError("unexpected cell in table view")
            }
            cell.selectionStyle = .none
            
            if let reviews = viewModel.commentSectionVM.value {
                let review = reviews[indexPath.row]
                cell.config(withReview: review, showSeparator: indexPath.row < viewModel.commentSectionVM.value!.count - 1)
            }
            
            return cell
        }
    }
}
