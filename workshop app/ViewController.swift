//
//  ViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit



extension UserPosts {
  var postsSummary : String {
    guard let latestPost = self.latestPost else {
      return "0 posts"
    }
    return "\(posts.count) posts, latest on \(latestPost.date)"
  }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  static let identifier = "user"
  @IBOutlet weak var tableView : UITableView!
  var userPosts : [UserPosts]?
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userPosts?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeueReusableCell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier, for: indexPath)
    
    guard let cell = dequeueReusableCell as? UserTableViewCell else {
      return dequeueReusableCell
    }
    
    guard let user = self.userPosts?[indexPath.row] else {
      return cell
    }
    
    cell.usernameLabel.text = user.user.name
    cell.badgeLabel.text = "\(user.user.badge)"
    cell.postsSummaryLabel.text = user.postsSummary
    
    
    guard let imageData = try? Data(contentsOf: user.user.avatar) else {
      return cell
    }
    
    guard let image = UIImage(data: imageData) else {
      return cell
    }
    
    cell.avatarView.image = image
    
    return cell
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    Database.shared.users { (userPosts) in
      self.userPosts = userPosts
      DispatchQueue.main.async {
        self.tableView.reloadData()        
      }
    }
  }
}

