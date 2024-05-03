//
//  FollowerListVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 3/5/24.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, error in
            guard let followers = followers else{
                self.presentGFAlertOnMainThread(title: "Error!", message: error ?? "Unable to fetch followers", buttonTitle: "OK")
                return
            }
            print(followers.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
