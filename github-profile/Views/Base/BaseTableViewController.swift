//
//  BaseTableViewController.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit
import Network

class BaseTableViewController: UITableViewController, NetworkCheckObserver {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    // MARK: - NetworkCheckObserver
    
    func networkStatusDidChange(status: NWPath.Status) {
        print("[BaseTableViewController:NetworkCheckObserver] Network status did change to: \(status)")

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
