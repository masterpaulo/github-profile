//
//  UserTableCellViewModel.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit

class UserTableCellViewModel: CellRepresentable {
    var cellIdentifier: String { return "UserTableViewCell" }
    
    var user: User
    var invertAvatar: Bool = false
    
    init(user: User, inverted: Bool = false) {
        self.user = user
        self.invertAvatar = inverted
    }
    
    var name: String {
        return user.login
    }
    
    var detail: String {
        return user.type.rawValue
    }
    
    var imageURL: String {
        return user.avatarURL
    }
    
    var hasNote: Bool {
        guard let note = user.note else { return false }
        return !note.isEmpty
    }
    
}
