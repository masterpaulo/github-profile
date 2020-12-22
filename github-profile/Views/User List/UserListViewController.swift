//
//  UserListViewController.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit
import Network

class UserListViewController: BaseTableViewController {
    
    var vm: UserListViewModel = UserListViewModel()
    
    @IBOutlet var searchBarView: UISearchBar!
    
    @IBOutlet var noTableDataView: UIView!
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        searchBarView.delegate = self
        setupViews()
        
        vm.viewDelegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
        
        vm.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshControl?.superview?.sendSubviewToBack(refreshControl!)
    }
    
    // MARK: - Setup
    
    override func registerCells() {
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func setupViews() {
        navigationItem.titleView = searchBarView
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    // MARK: - Methods
    
    func didScrollToBottom(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            vm.loadMore()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didScrollToBottom(scrollView: scrollView)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didScrollToBottom(scrollView: scrollView)
    }
    
    // MARK: - Actions
    
    @objc func refresh(_ sender: AnyObject) {
        // Cancel search
        searchBarView.text = ""
        searchBarView.endEditing(true)
        searchBarView.setShowsCancelButton(false, animated: true)
        vm.cancelSearch()
        
        // Get fresh set of user list
        vm.getUsers()
    }
    
    // MARK: - NetworkCheckObserver
    
    override func networkStatusDidChange(status: NWPath.Status) {
        super.networkStatusDidChange(status: status)
        if status == .satisfied {
            vm.loadData()
        }
        updateView()
    }
}

// MARK: - Table Builder

extension UserListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfRowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellVM = vm.cellViewModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.cellIdentifier) as? BaseTableViewCell
        
        cell?.configure(representable: cellVM)
        
        cell?.layoutIfNeeded()
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.selectUser(at: indexPath)
    }
}

// MARK: - UserListViewModelViewDelegate

extension UserListViewController: UserListViewModelViewDelegate {
    func updateView() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func showUserProfile(with userProfileVM: UserProfileViewModel) {
        let vc = UserProfileViewController.instantiate(fromAppStoryboard: .main)
        vc.vm = userProfileVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNoTableData(_ show: Bool) {
        tableView.backgroundView = show ? noTableDataView : nil
    }
}

// MARK: - UISearchBarDelegate

extension UserListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        vm.cancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        vm.search(for: text ?? "")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        vm.searchMode = true
        updateView() // Update view to hide loading table cell
    }
}
