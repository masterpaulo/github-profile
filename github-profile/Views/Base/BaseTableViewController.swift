//
//  BaseTableViewController.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit
import Network

class BaseTableViewController: UITableViewController, NetworkCheckObserver {
    
    var warningLabel: UILabel?
    
    var isOnline: Bool {
        return NetworkCheck.sharedInstance().isOnline
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isOnline {
            hideNoNetworkWarning()
        }
        else {
            showNoNetworkWarning()
        }
        
        NetworkCheck.sharedInstance().addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    deinit {
        NetworkCheck.sharedInstance().removeObserver(observer: self)
    }
    
    // MARK: - Setup
    
    /// Register cells to be used by the table view
    func registerCells() {
        preconditionFailure("This method must be overridden")
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
        guard let nav = self.navigationController else { return }
        let warningLabel = UILabel()
        warningLabel.backgroundColor = .red
        warningLabel.textColor = . white
        warningLabel.textAlignment = .center
        warningLabel.text = "No connection"
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        nav.view.addSubview(warningLabel)
        nav.view.bringSubviewToFront(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.heightAnchor.constraint(equalToConstant: 20),
            warningLabel.bottomAnchor.constraint(equalTo: nav.view.bottomAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: nav.view.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: nav.view.trailingAnchor)
        ])
        
        self.warningLabel = warningLabel
        
        nav.view.layoutIfNeeded()
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


// MARK: - Universal handlers

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
