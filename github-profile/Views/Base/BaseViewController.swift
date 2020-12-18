//
//  BaseViewController.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit
import Network

class BaseViewController: UIViewController, NetworkCheckObserver {
    
    var warningLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkCheck.sharedInstance().addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    deinit {
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    // MARK: - Methods
    
    // Show default system alert with title and message
    func showDefaultAlert(title: String?, message: String?, _ completion: (()-> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            print("OK Button tapped")
            completion?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoNetworkWarning() {
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
