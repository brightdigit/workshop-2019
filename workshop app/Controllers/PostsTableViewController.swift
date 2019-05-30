//
//  PostsTableViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/23/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit




class PostsTableViewController: UITableViewController {
  static let identifer = "post"
  var posts : [PostEmbedded]?
  
  var origin : Origin?
  
  enum Origin {
    case author(UUID), post(UUID)
    
    
    var filter : PostFilter {
      switch self {
      case .post(let id): return .authorWithPost(id)
      case .author(let id): return .author(id)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.register(UINib(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "post")
    self.tableView.estimatedRowHeight = 282
    self.navigationItem.title = self.origin != nil ? "Loading..." : "Posts"
    Database.shared.posts(filteredBy: origin?.filter) { (posts) in
      self.posts = posts
      DispatchQueue.main.async {
        if let name = posts.first?.author.name, self.origin != nil {
          self.navigationItem.title = name
        }
        self.tableView.reloadData()
      }
    }
    
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.posts?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewController.identifer, for: indexPath)
    
    guard let cell = dequeuedCell as? PostsTableViewCell else {
      return dequeuedCell
    }
    
    guard let post = self.posts?[indexPath.row] else {
      return cell
    }
    
    
    let postTask = Cache.shared.loadImage(fromURL: post.post.image, ofType: .post, withUUID: post.post.id) { (image, method) in
      cell.postImageView.image = image
    }
      
    if postTask != nil {
      cell.postImageView.image = nil
    }
    
    let avatarTask = Cache.shared.loadImage(fromURL: post.author.avatar, ofType: .avatar, withUUID: post.author.id) { (image, method) in
      cell.authorImageView.image = image
    }
    
    if avatarTask != nil {
      cell.authorImageView.image = nil
    }
    
    cell.authorNameLabel.text = post.author.name
    cell.postTitleLabel.text = post.post.title
    cell.publishDateLabel.text = WSDateFormatter.default.string(from: post.post.date)
    cell.bodyLabel.text = post.post.text
    cell.bodyLabel.numberOfLines = 3
    cell.commentSummaryLabel.text = "\(post.comments.count) comments"
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard origin != nil else {
      return nil
    }
    
    guard let user = self.posts?.first?.author else {
      return nil
    }
    
    let userView : UsersTableViewCell = .fromNib()
    
    let avatarTask = Cache.shared.loadImage(fromURL: user.avatar, ofType: .avatar, withUUID: user.id) { (image, method) in
      userView.avatarView.image = image
    }
    
    if avatarTask != nil {
      userView.avatarView.image = nil
    }
    
    var summaryText = "\(posts?.count ?? 0) posts"
    if let startDate = posts?.last?.post.date {
      summaryText.append(" since \(WSDateFormatter.default.string(from: startDate))")
    }
    userView.badgeLabel.text = "\(user.badge)"
    userView.usernameLabel.text = user.name
    userView.postsSummaryLabel.text = summaryText
    
    return userView
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return origin != nil ? 136.0 : 0.0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let postId = self.posts?[indexPath.row].post.id else {
      return
    }
    
    let viewController = CommentsTableViewController()
    viewController.origin = .post(postId)
    self.navigationController?.pushViewController(viewController, animated: true)
    //self.performSegue(withIdentifier: "postComments", sender: tableView)
  }

  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation

  
}

extension PostsTableViewController : TabItemable {
  func configureTabItem(_ tabItem: UITabBarItem) {
    tabBarItem.title = "Posts"
    tabBarItem.image = UIImage(named: "Post")
  }
}