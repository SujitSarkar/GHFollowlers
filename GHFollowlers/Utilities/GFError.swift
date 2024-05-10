//
//  GFError.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 5/5/24.
//

import Foundation

enum GFError: String, Error{
    case invalidUsername = "Invalid username."
    case unableToComplete = "Unable to complete the request."
    case invalidResponse = "Invalid respose from the server."
    case invalidData = "Invalid data from the server."
    case dataParsingError = "The data received from the server is invalid."
    case somethingWentWrong = "Something Went Wrong."
    case unableToFavorite = "There was an error favoriting this user. PLease try again."
    case alreadyInFavorites = "You have already favorited this user. You must really like them!"
}
