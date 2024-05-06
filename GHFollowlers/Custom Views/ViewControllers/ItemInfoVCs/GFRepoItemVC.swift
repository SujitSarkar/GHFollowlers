//
//  GFRepoItemVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 7/5/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: ItemInfoType.repos, withCount: user.publicRepos ?? 0)
        itemInfoViewTwo.set(itemInfoType: ItemInfoType.gists, withCount: user.publicGists ?? 0)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
}
