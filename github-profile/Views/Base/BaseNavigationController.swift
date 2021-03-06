//
//  BaseNavigationController.swift
//  github-profile
//
//  Created by John Paulo on 12/22/20.
//

import UIKit
import Network

class BaseNavigationController: UINavigationController, NetworkCheckObserver {
    
    var warningLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkCheck.sharedInstance().addObserver(observer: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if NetworkCheck.sharedInstance().isOnline {
            hideNoNetworkWarning()
        }
        else {
            showNoNetworkWarning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    deinit {
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    // MARK: - Methods
    
    func showNoNetworkWarning() {
        guard self.warningLabel == nil else { return }
        let warningLabel = UILabel()
        warningLabel.backgroundColor = .red
        warningLabel.textColor = . white
        warningLabel.textAlignment = .center
        warningLabel.text = "No connection"
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
        view.bringSubviewToFront(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.heightAnchor.constraint(equalToConstant: 20),
            warningLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.warningLabel = warningLabel
        
        view.layoutIfNeeded()
    }
    
    func hideNoNetworkWarning() {
        warningLabel?.removeFromSuperview()
        warningLabel = nil
    }
    
    // MARK: - NetworkCheckObserver
    
    func networkStatusDidChange(status: NWPath.Status) {
        print("[BaseTableViewController:NetworkCheckObserver] Network status did change to: \(status)")
        if status == .satisfied {
            hideNoNetworkWarning()
        }
        else {
            showNoNetworkWarning()
        }
    }
}
