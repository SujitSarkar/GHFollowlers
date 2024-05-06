//
//  User.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 4/5/24.
//

import Foundation

struct User: Codable, Hashable{
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos, publicGists, followers, following: Int?
    let createdAt: String
}
