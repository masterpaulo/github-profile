//
//  BaseTableViewCell.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit

protocol CellRepresentable {
    var cellIdentifier: String { get }
}

class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(representable: CellRepresentable) {
        preconditionFailure("This method must be overridden")
    }
}
