//
//  GfFollowerItemVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 7/5/24.
//

import UIKit

class GfFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: ItemInfoType.followers, withCount: user.followers ?? 0)
        itemInfoViewTwo.set(itemInfoType: ItemInfoType.following, withCount: user.following ?? 0)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
