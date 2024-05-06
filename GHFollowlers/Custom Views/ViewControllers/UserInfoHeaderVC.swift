//
//  UserInfoHeaderVC.swift
//  GHFollowlers
//
//  Created by Sujit Sarkar on 6/5/24.
//

import UIKit

class UserInfoHeaderVC: UIViewController {
    let avaterImageView     = GFAvatarImageView(frame: .zero)
    let userNameLabel       = GFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel           = GFSecondaryTitleLabel(fontSize: 18)
    let locationImageView   = UIImageView()
    let locationLabel       = GFSecondaryTitleLabel(fontSize: 18)
    let bioLabel            = GFBodyLabel(textAlignment: .left)
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        layoutUI()
        configureUIElements()
    }
    
    func configureUIElements(){
        avaterImageView.downloadImage(from: user.avatarUrl)
        userNameLabel.text          = user.login
        nameLabel.text              = user.name ?? "NA"
        locationLabel.text          = user.location ?? "NA"
        bioLabel.text               = user.bio ?? "NA"
        bioLabel.numberOfLines      = 3
        locationImageView.image     = UIImage(systemName: SFSymbol.location)
        locationImageView.tintColor = .secondaryLabel
    }
    
    private func addSubViews(){
        view.addSubview(avaterImageView)
        view.addSubview(userNameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }
    
    private func layoutUI(){
        let textImagePadding: CGFloat   = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avaterImageView.topAnchor.constraint(equalTo: view.topAnchor),
            avaterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avaterImageView.widthAnchor.constraint(equalToConstant: 90),
            avaterImageView.heightAnchor.constraint(equalToConstant: 90),
            
            userNameLabel.topAnchor.constraint(equalTo: avaterImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avaterImageView.trailingAnchor, constant: textImagePadding),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avaterImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avaterImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avaterImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avaterImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor,constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avaterImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avaterImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

}
