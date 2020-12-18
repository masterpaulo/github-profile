//
//  UserListViewModel.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import Foundation

protocol UserListViewModelViewDelegate {
    func updateView()
    func showUserProfile(with userProfileVM: UserProfileViewModel)
}

class UserListViewModel {
    var viewDelegate: UserListViewModelViewDelegate?
    
    var userList: [User] = []
    var lastFetchSince: Int = 0
    var pageSize: Int? // Page size is nil by default
    var searchText: String = ""
    
    var searchMode: Bool = false
    var isLoadingMore: Bool = false
    
    var filterdList: [User] {
        guard !searchText.isEmpty else { return userList }
        return userList.filter { user in
            if user.login.lowercased().contains(searchText.lowercased()) {
                return true
            }
            
            if let note = user.note, note.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        }
    }
    
    init() {
        
        //userList = UserList(users: users)
    }
    
    // MARK: - Setup
    
    func loadData() {
        // Load saved user list from core data and display if list has items
        DataManager.shared.loadSavedData()
        let loadedUsers = DataManager.shared.userList
        if loadedUsers.count > 0 {
            self.userList = loadedUsers
            self.viewDelegate?.updateView()
        }
        
        // else show empty table view
        
        if NetworkCheck.sharedInstance().isOnline {
            getUsers()
        }
    }
    
    
    func cellViewModels() -> [CellRepresentable] {
        var cellVMs: [CellRepresentable] = filterdList.enumerated().map { index, user in
            // Apply switch control
            let isInverted: Bool = (index + 1) % 4 == 0
            return UserTableCellViewModel(user: user, inverted: isInverted)
        }
        if !searchMode, NetworkCheck.sharedInstance().isOnline { // !cellVMs.isEmpty,
            cellVMs.append(LoadingCellViewModel())
        }
        
        return cellVMs
    }
    
    // MARK: - Methods
    
    func search(for text: String) {
        searchMode = true
        searchText = text
        viewDelegate?.updateView()
    }
    
    func cancelSearch() {
        searchMode = false
        searchText = ""
        viewDelegate?.updateView()
    }
    
    func selectUser(at indexPath: IndexPath) {
        guard let user = filterdList[safe: indexPath.item] else { return }
        let userProfileVM = UserProfileViewModel(user: user)
        viewDelegate?.showUserProfile(with: userProfileVM)
    }
    
    func loadMore() {
        // Do not load more users if in searh mode
        guard !searchMode, !isLoadingMore else { return }
        isLoadingMore = true
        getUsers(since: lastFetchSince, pageSize: pageSize)
    }
    
}

// MARK: - BaseTableViewModelProtocol

extension UserListViewModel: BaseTableViewModelProtocol {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return cellViewModels().count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CellRepresentable {
        return cellViewModels()[indexPath.item]
    }
}

// MARK: - Network Calls

extension UserListViewModel {
    func getUsers(since: Int = 0, pageSize: Int? = nil) {
        APIManager().getUsers(since: since, pageSize: pageSize) { result in
            self.isLoadingMore = false
            switch result {
            case .success(let users):
                
                // Set page size on first successful request.
                if self.pageSize == 0 {
                    self.pageSize = users.count
                }
                
                // If since value is zero, it is treated as a fresh batch (fetch from the start).
                // Commonly used for first load and refreshing data
                if since == 0 {
                    // Use the first batch's total count as the page size
                    // for any proceeding request from the current batch
                    // Will reset if refreshing batch
                    self.pageSize = users.count
                    
                    // overwrite current user list if fetching fresh batch
                    self.userList = DataManager.shared.setUserList(to: users)
                    DataManager.shared.saveContext()
                    
                }
                else {
                    
                    // Append results to current user list if fetching since value is not zero
                    self.userList = DataManager.shared.updateUserList(with: users)
                    DataManager.shared.saveContext()
                    
                }
                
                // Update last fetch since with the value of the last user's id
                self.lastFetchSince = self.userList.last?.id ?? 0
                
                // Signal the view delegate to update view in main thread
                DispatchQueue.main.async {
                    self.viewDelegate?.updateView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
