//
//  BaseTableViewModel.swift
//  github-profile
//
//  Created by Master Paulo on 12/16/20.
//

import Foundation

protocol BaseTableViewModelProtocol {
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    
    func cellViewModel(at indexPath: IndexPath) -> CellRepresentable
}
