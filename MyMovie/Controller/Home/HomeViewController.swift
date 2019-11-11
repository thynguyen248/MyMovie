//
//  HomeViewController.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/5/19.
//

import UIKit
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
    
    private func binding(sectionViewModel: BehaviorRelay<HorizontalListViewModel?>, type: SectionType) {
        
        sectionViewModel.subscribe(onNext: { [weak self] _ in
            guard let sectionViewModelValue = sectionViewModel.value else {
                return
            }
            
            // Reload section
            self?.tableView.reloadData()
            
            // Load more
            sectionViewModelValue.isLoadingMore.subscribe(onNext: { [weak self] loadingMoreType in
                guard let loadingMoreType = loadingMoreType else {
                    return
                }
                self?.viewModel.loadMovieList(type: loadingMoreType)
                
            }, onError: { [weak self] error in
                self?.showAlerWithMessage(error.localizedDescription)
            }).disposed(by: self?.disposeBag ?? DisposeBag())
            
        }, onError: { [weak self] error in
            self?.showAlerWithMessage(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    private func setupViewModel() {
        // Loading indicator
        viewModel.isLoading.bind(to: isLoading).disposed(by: disposeBag)
        viewModel.isLoading.bind(to: isRefreshing).disposed(by: disposeBag)
        
        // Recommendation
        binding(sectionViewModel: viewModel.recommendationSectionVM, type: .Recommendation)
        
        // Category
        binding(sectionViewModel: viewModel.categorySectionVM, type: .Category)
        
        // Popular
        binding(sectionViewModel: viewModel.popularSectionVM, type: .Popular)
        
        // Top rated
        binding(sectionViewModel: viewModel.topRatedSectionVM, type: .TopRated)
        
        // Upcoming
        binding(sectionViewModel: viewModel.upcomingSectionVM, type: .Upcoming)
        
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
        configDefaultTheme()
    }
    
    private func setupTableView() {
        tableView.register(HorizontalListTableViewCell.nib, forCellReuseIdentifier: HorizontalListTableViewCell.identifier)
        tableView.register(TitleHeaderView.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifier)
    }
    
    private func reloadSection(sectionType: SectionType) {
        if let sectionIndex = viewModel.sections.firstIndex(where: { $0 == sectionType }) {
            tableView.reloadSections(IndexSet([sectionIndex]), with: .none)
        }
    }
    
    private func setupRefreshControl() {
        addRefresherToList(tableView)
        refresher!.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        if isRefreshing.value {
            return
        }
        isRefreshing.accept(true)
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
        if isLoading.value {
            return
        }
        isLoading.accept(true)
        viewModel.reset()
        viewModel.loadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            return 0
        }
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = viewModel.sections[section]
        guard !(viewModel.getSectionViewModel(withType: sectionType)?.dataList ?? []).isEmpty else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.identifier) as! TitleHeaderView
        headerView.titleLabel.text = sectionType.description
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
        
        return cell
    }
}

