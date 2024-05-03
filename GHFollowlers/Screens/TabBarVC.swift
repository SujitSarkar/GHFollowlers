//
//  TabBarVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 1/5/24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let searchVC    = UINavigationController(rootViewController: SearchVC())
        let favoriteCV  = UINavigationController(rootViewController: FavoriteVC())

        searchVC.tabBarItem     = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        favoriteCV.tabBarItem   = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        tabBar.tintColor        = .systemGreen
     
        setViewControllers([searchVC, favoriteCV], animated: true)
    }

}
