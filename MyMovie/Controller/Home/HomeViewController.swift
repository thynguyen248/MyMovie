//
//  HomeViewController.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupViewModel()
        loadData()
    }
    
    private func binding(sectionViewModel: BehaviorRelay<HorizontalListViewModel?>) {
        sectionViewModel.subscribe(onNext: { [weak self] sectionVM in
            self?.tableView.reloadData()
            }, onError: { [weak self] error in
                self?.showAlerWithMessage(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        // Loading indicator
        viewModel.isLoading.bind(to: isLoading).disposed(by: disposeBag)
        viewModel.isLoading.bind(to: isRefreshing).disposed(by: disposeBag)
        
        // Recommendation
        binding(sectionViewModel: viewModel.recommendationSectionVM)
        
        // Category
        binding(sectionViewModel: viewModel.categorySectionVM)
        
        // Popular
        binding(sectionViewModel: viewModel.popularSectionVM)
        
        // Top rated
        binding(sectionViewModel: viewModel.topRatedSectionVM)
        
        // Upcoming
        binding(sectionViewModel: viewModel.upcomingSectionVM)
        
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
        bindLoadingIndicator(loadingIndicator)
    }
    
    private func setupNavigationBar() {
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
        
        addLeftBarButton(withImage: UIImage(named: "default-user")!)
        addRightBarButton(withImage: UIImage(named: "search-icon")!)
        
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 15.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
    }
    
    private func setupTableView() {
        tableView.register(HorizontalListTableViewCell.nib, forCellReuseIdentifier: HorizontalListTableViewCell.identifier)
        tableView.register(TitleHeaderView.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifier)
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
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
        if isLoading.value {
            return
        }
        isLoading.accept(true)
        viewModel.loadData()
    }
    
    private func reloadData() {
        if isRefreshing.value {
            return
        }
        isRefreshing.accept(true)
        viewModel.loadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.movieToMovieDetail.rawValue {
            guard let movieId = sender as? Int, let detailVC = segue.destination as? MovieDetailViewController else {
                return
            }
            detailVC.movieId = movieId
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        return (viewModel.getSectionViewModel(withType: sectionType)?.dataList ?? []).isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = viewModel.sections[indexPath.section]
        return sectionType.itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = viewModel.sections[section]
        guard !(viewModel.getSectionViewModel(withType: sectionType)?.dataList ?? []).isEmpty else {
            return .leastNormalMagnitude
        }
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = viewModel.sections[section]
        guard !(viewModel.getSectionViewModel(withType: sectionType)?.dataList ?? []).isEmpty else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.identifier) as! TitleHeaderView
        headerView.titleLabel.text = sectionType.description.uppercased()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalListTableViewCell.identifier, for: indexPath) as? HorizontalListTableViewCell else {
            fatalError("unexpected cell in table view")
        }
        
        let sectionType = viewModel.sections[indexPath.section]
        guard let sectionVM = viewModel.getSectionViewModel(withType: sectionType) else {
            return cell
        }
        
        cell.viewModel.accept(sectionVM)
        cell.didSelectId = { [weak self] selectedId in
            self?.performSegue(withIdentifier: Segue.movieToMovieDetail.rawValue, sender: selectedId)
        }
        
        return cell
    }
}

