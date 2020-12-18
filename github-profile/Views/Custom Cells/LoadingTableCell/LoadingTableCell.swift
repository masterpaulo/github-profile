//
//  LoadingTableCell.swift
//  github-profile
//
//  Created by John Paulo on 12/17/20.
//

import UIKit

class LoadingTableCell: BaseTableViewCell {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    // We can add a label here to show some text while loading
    // @IBOutlet weak var textLabel: UILabel!
    
    override func configure(representable: CellRepresentable) {
        //guard let viewModel = representable as? LoadingCellViewModel else { return }
        loadingIndicator.startAnimating()
    }
}

