//
//  FollowerListVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 3/5/24.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject{
    func didRequestFollowers(for username: String)
}

class FollowerListVC: UIViewController {
    
    enum Section{case main}
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var username: String!
    var page: Int = 1
    var hasMoreFollowers: Bool = true
    var isSearching: Bool = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        fetchFollowers(username: username, page: page)
        configureDatSource()
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dismisLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else {return}
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "OK")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Failed!", message: error.rawValue, buttonTitle: "OK")
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "Close")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
    }
    
    func configureSearchController(){
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = "Search for a user"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController         = searchController
    }
    
    func fetchFollowers(username: String, page: Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            self.dismisLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                
                if followers.isEmpty {
                    DispatchQueue.main.async {
                        let message = "This user does not have any follower. Go follow them 😄"
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                }
                
                self.updateData(for: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error!", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func configureDatSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else { return UICollectionViewCell() }
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(for followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) {
            guard hasMoreFollowers else {return}
            page += 1
            fetchFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray         = isSearching ? filteredFollowers : followers
        let follower            = activeArray[indexPath.row]
        let userInfoVC          = UserInfoVC()
        userInfoVC.username     = follower.login
        userInfoVC.delegate     = self
        let navController       = UINavigationController(rootViewController: userInfoVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filterText = searchController.searchBar.text, !filterText.isEmpty else {
            isSearching = false
            updateData(for: self.followers)
            return
        }
        filteredFollowers = followers.filter{$0.login.lowercased().contains(filterText.lowercased())}
        isSearching = true
        updateData(for: filteredFollowers)
    }
    
}

extension FollowerListVC: FollowerListVCDelegate{
    
    func didRequestFollowers(for username: String) {
        self.username = username
        self.title = username
        self.page = 1
        self.followers.removeAll()
        self.filteredFollowers.removeAll()
        self.fetchFollowers(username: username, page: page)
        self.collectionView.reloadData()
        self.collectionView.setContentOffset(.zero, animated: true)
    }
}
