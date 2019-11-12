//
//  MovieDetailViewController.swift
//  MyMovie
//
//  Created by Thy Nguyen on 11/11/19.
//

import UIKit

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
        
        viewModel.movieDetail.asDriver(onErrorJustReturn: nil).drive(onNext: { [weak self] _ in
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
        tableView.register(TitleHeaderView.nib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.identifier)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieDetail.value == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .Media:
            let videoHeight = UIScreen.main.bounds.size.width * 9 / 16
            return videoHeight + 109.0 + 16.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = viewModel.sections[section]
        guard !sectionType.description.isEmpty, viewModel.movieDetail.value != nil else {
            return 0
        }
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = viewModel.sections[section]
        guard !sectionType.description.isEmpty, viewModel.movieDetail.value != nil else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.identifier) as! TitleHeaderView
        headerView.titleLabel.text = sectionType.description
        headerView.bgView.backgroundColor = .lightGray
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
        default:
            return UITableViewCell()
        }
    }
}
