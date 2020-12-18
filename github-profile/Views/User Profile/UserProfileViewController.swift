//
//  UserProfileViewController.swift
//  github-profile
//
//  Created by John Paulo on 12/16/20.
//

import UIKit
import Network

class UserProfileViewController: BaseViewController {
    
    var vm: UserProfileViewModel! // required to function properly
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerBackgroundImageView: UIImageView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLable: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        vm.viewDelegate = self
        vm.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    // MARK: - Setup
    
    func setupViews() {
        navigationItem.title = vm.titleText
        
        headerImageView.loadImage(fromURL: vm.imageURL)
        headerBackgroundImageView.loadImage(fromURL: vm.imageURL)
        
        followerCountLabel.text = vm.followerCountText
        followingCountLable.text = vm.followingCountText
        
        nameLabel.text = vm.nameText
        companyLabel.text = vm.companyText
        blogLabel.text = vm.blogText
        
        notesTextView.text = vm.noteText
    }
    
    
    
    // MARK: - Methods
    
    
    // MARK: - Actions
    
    @IBAction func saveButtonAction(_ sender: Any) {
        vm.saveNote(notesTextView.text ?? "")
        showDefaultAlert(title: "Save Complete", message: "Successfully updated your note")
    }
    
    // MARK: - NetworkCheckObserver
    
    override func networkStatusDidChange(status: NWPath.Status) {
        super.networkStatusDidChange(status: status)
        if status == .satisfied {
            vm.loadData()
        }
        updateView()
    }
}

// MARK: - UserProfileViewModelViewDelegate

extension UserProfileViewController: UserProfileViewModelViewDelegate {
    func updateView() {
        setupViews()
    }
    
    func showLoadingIndicator(_ show: Bool) {
        // Show activity indicator somewhere
    }
}
