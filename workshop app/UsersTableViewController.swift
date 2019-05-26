//
//  ViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit



extension EmbedUser {
  var postsSummary : String {
    guard let latestPost = self.latestPost else {
      return "0 posts"
    }
    return "\(posts.count) posts, latest on \(latestPost.date)"
  }
}

class UsersTableViewController: UITableViewController {
  static let identifier = "user"
  var users : [EmbedUser]?
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeueReusableCell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewController.identifier, for: indexPath)
    
    guard let cell = dequeueReusableCell as? UsersTableViewCell else {
      return dequeueReusableCell
    }
    
    guard let user = self.users?[indexPath.row] else {
      return cell
    }
    
    cell.usernameLabel.text = user.user.name
    cell.badgeLabel.text = "\(user.user.badge)"
    cell.postsSummaryLabel.text = user.postsSummary

    let task = Cache.shared.loadImage(fromURL: user.user.avatar, ofType: .avatar, withUUID: user.user.id) { (image, method) in
      cell.avatarView.image = image
    }
    
    if task != nil {
      cell.avatarView.image = nil
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let user = self.users?[indexPath.row] else {
      return
    }
    let viewController = PostsTableViewController()
    viewController.origin = .author(user.user.id)
    self.navigationController?.pushViewController(viewController, animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.navigationItem.title = "Users"
    self.tableView.register(UINib(nibName: "UsersTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "user")
    Database.shared.users { (userPosts) in
      self.users = userPosts
      DispatchQueue.main.async {
        self.tableView.reloadData()        
      }
    }
  }
}


extension UsersTableViewController : TabItemable {
  func configureTabItem(_ tabItem: UITabBarItem) {
    tabBarItem.title = "Users"
    tabBarItem.image = UIImage(named: "User")
  }
}
