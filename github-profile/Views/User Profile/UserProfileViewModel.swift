//
//  UserProfileViewModel.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import Foundation

protocol UserProfileViewModelViewDelegate {
    func updateView()
    func showLoadingIndicator(_ show: Bool)
}

class UserProfileViewModel {
    var viewDelegate: UserProfileViewModelViewDelegate?

    var user: User
    
    var isLoading: Bool = false {
        didSet {
            self.viewDelegate?.showLoadingIndicator(isLoading)
        }
    }

    init(user: User) {
        self.user = user
    }
    
    // MARK: - Setup
    
    func loadData() {
        // if local data available
        
        // else show empty table view
        
        if NetworkCheck.sharedInstance().isOnline {
            getUser(username: user.login)
        }
    }
    
    // MARK: - Methods
    
    func saveNote(_ text: String) {
        user.note = text
        DataManager.shared.addOrUpdate(user: user)
        //DataManager.shared.set(note: text, for: user)
        DataManager.shared.saveContext()
    }
    
    // MARK: - Display Properties
    
    var imageURL: String { return user.avatarURL}
    var titleText: String { return user.login }
    var followerCountText: String { return "\(user.followers ?? 0)"}
    var followingCountText: String { return "\(user.following ?? 0)"}
    
    var nameText: String { return user.name ?? "" }
    var companyText: String {
        guard let company = user.company else { return "" }
        return "Works at: \(company)"
    }
    var blogText: String {
        guard let blog = user.blog else { return "" }
        return "Checkout blog here: \(blog)" }
    
    var noteText: String { return user.note ?? "" }
}

// MARK: - Network Calls

extension UserProfileViewModel {
    func getUser(username: String) {
        self.isLoading = true
        APIManager().getUser(username: username) { result in
            self.isLoading = false
            switch result {
            case .success(let user):
                
                // Add/Update user data on DB and get final value
                let newUserData = DataManager.shared.addOrUpdate(user: user)
                DataManager.shared.saveContext()
                self.user.configuer(with: newUserData)
                
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
