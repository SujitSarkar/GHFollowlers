//
//  FavoritesListVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 1/5/24.
//

import UIKit

class FavoriteVC: UIViewController {
    
    let tableView = UITableView()
    var favorites = [Follower]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
    
    func configureViewController(){
        title  = "Favorites"
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
    }

    func fetchFavorites(){
        PersistenceManager.retriveFavorites { [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let favorites):
                if favorites.isEmpty{
                    self.showEmptyStateView(with: "No Favorite!\nAdd on the follower screen.", in: self.view)
                }else{
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error!", message: error.localizedDescription, buttonTitle: "Close")
            }
        }
    }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier,for: indexPath) as? FavoriteCell else { return UITableViewCell() }
        let favorite = favorites[indexPath.row]
        cell.set(for: favorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite                = favorites[indexPath.row]
        let followerListVC          = FollowerListVC()
        followerListVC.username     = favorite.login
        followerListVC.title        = favorite.login
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let favorite = favorites[indexPath.row]
        
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else {return}
            guard let error = error else {return}
            self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "Close")
        }
    }
    
}
