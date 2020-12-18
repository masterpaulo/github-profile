//
//  UserTableViewCell.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit

class UserTableViewCell: BaseTableViewCell {
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var detailTitleLabel: UILabel!
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var noteIconImageView: UIImageView!
    
    
    override func configure(representable: CellRepresentable) {
        guard let viewModel = representable as? UserTableCellViewModel else { return }
        
        mainTitleLabel.text = viewModel.name
        detailTitleLabel.text = viewModel.detail
        
        // Configure avatar image view
        avatarImageView.backgroundColor = viewModel.invertAvatar ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        avatarImageView.loadImage(fromURL: viewModel.imageURL, inverted: viewModel.invertAvatar)
        
        
        // Hide note icon if user has no note
        noteIconImageView.isHidden = !viewModel.hasNote
        
    }
}
