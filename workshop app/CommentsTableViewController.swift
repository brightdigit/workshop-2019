//
//  CommentsTableViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

enum CommentsOrigin {
  case post(UUID), comment(UUID)
  
  var filter : CommentFilter {
    switch self {
    case .comment(let id): return .postWithComment(id)
    case .post(let id): return .post(id)
    }
  }
  
  var selection : PostSelection {
    switch self {
    case .comment(let id): return .comment(id)
    case .post(let id): return .post(id)
    }
  }
}

class CommentsTableViewController: UITableViewController {
  static let identifer = "comment"
  var comments : [EmbedComment]?
  
  var post: EmbedPost?
  var origin : CommentsOrigin?
  weak var alertController : UIAlertController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = self.origin != nil ? "Loading..." : "Comments"
    self.tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "comment")
    let group = DispatchGroup()
    
    group.enter()
    Database.shared.comments(filteredBy: origin?.filter) {
      self.comments = $0
      group.leave()
    }
    
    if let origin = self.origin {
      
      self.tableView.register(UINib(nibName: "PostView", bundle: Bundle.main), forCellReuseIdentifier: "post")
      self.tableView.estimatedSectionHeaderHeight = tableView.frame.width / 3.0 * 2.0 + 300
      self.tableView.sectionHeaderHeight = UITableView.automaticDimension
      group.enter()
      Database.shared.post(selectedBy: origin.selection) {
        self.post = $0
        group.leave()
      }
    }
    
    group.notify(queue: .main) {
      if let title = self.comments?.first?.post.title, self.origin != nil {
        self.navigationItem.title = title
      }
      self.tableView.reloadData()
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return post != nil ? 2 : 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return post != nil && section == 0 ? 1 : comments?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, commentCellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewController.identifer, for: indexPath)
    
    guard let cell = dequeuedCell as? CommentsTableViewCell else {
      return dequeuedCell
    }
    
    guard let comment = self.comments?[indexPath.row] else {
      return cell
    }
    
    
    
    if let image = Cache.shared.object(forKey: CacheImageKey(type: .avatar, uuid: comment.author.id)) {
      cell.authorImageView.image = image
    } else {
      cell.authorImageView.image = nil
      URLSession.shared.dataTask(with: comment.author.avatar)  { (data, _, _) in
        
        guard let data = data else {
          return
        }
        
        guard let image = UIImage(data: data) else {
          return
        }
        
        Cache.shared.setObject(image, forKey: CacheImageKey(type: .avatar, uuid: comment.author.id))
        
        DispatchQueue.main.async {
          guard let cell = tableView.cellForRow(at: indexPath) as? PostsTableViewCell else {
            return
          }
          cell.authorImageView.image = image
        }
        }.resume()
    }
    cell.authorNameLabel.text = comment.author.name
    cell.postTitleLabel.text = comment.post.title
    cell.dateLabel.text = WSDateFormatter.default.string(from: comment.comment.date)
    cell.bodyLabel.text = comment.comment.text
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if origin != nil && indexPath.section == 0 {
      return self.tableView(tableView, postCellForRowAt: indexPath)
    } else {
      return self.tableView(tableView, commentCellForRowAt: indexPath)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.origin != nil {
      guard let userId = self.comments?[indexPath.row].author.id else {
        return
      }
      //self.performSegue(withIdentifier: "Comment Author", sender: tableView)
      let viewController = PostsTableViewController()
      viewController.origin = .author(userId)
      self.navigationController?.pushViewController(viewController, animated: true)
      return
    } else {
      let alertController = UIAlertController(title: nil, message: "What would you like to see?", preferredStyle: .actionSheet)
      for action in Action.allCases {
        alertController.addAction(UIAlertAction(title: action.rawValue, style: .default, handler: self.onComment(alertAction:)))
      }
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  enum Action : String, CaseIterable {
    case post = "Post", user = "Comment Author"
    
    func viewController(forComment comment: Comment) -> UIViewController {
      switch self {
      case .post:
        let viewController = CommentsTableViewController()
        viewController.origin = .comment(comment.id)
        return viewController
      case .user:
        let viewController = PostsTableViewController()
        viewController.origin = .author(comment.userId)
        return viewController
      }
    }
  }
  
  func onComment(alertAction: UIAlertAction) {
    guard let title = alertAction.title else {
      return
    }
    guard let action = Action(rawValue: title) else {
      return
    }
    guard let indexPath = self.tableView.indexPathForSelectedRow else {
      return
    }
    guard let comment = self.comments?[indexPath.row] else {
      return
    }
    self.navigationController?.pushViewController(action.viewController(forComment: comment.comment), animated: true)
    self.alertController = nil
  }
  
  func tableView(_ tableView: UITableView, postCellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath)
    
    guard let postView = dequeuedCell as? PostsTableViewCell else {
      return dequeuedCell
    }
    
    guard let post = post else {
      return postView
    }
    postView.authorNameLabel.text = post.author.name
    postView.bodyLabel.text = post.post.text
    postView.postTitleLabel.text = post.post.title
    postView.publishDateLabel.text = WSDateFormatter.default.string(from: post.post.date)
    
    if let commentSummaryLabel = postView.commentSummaryLabel {
      commentSummaryLabel.removeFromSuperview()
    }
    
    _ = Cache.loadImage(fromURL: post.post.image, ofType: .post, withUUID: post.post.id) { (image, method) in
      guard let image = image else {
        return
      }
      
      if case .cached = method {
        postView.postImageView.image = image
        return
      }
      
      DispatchQueue.main.async {
        postView.postImageView.image = image
      }
    }
    
    _ = Cache.loadImage(fromURL: post.author.avatar, ofType: .avatar, withUUID: post.author.id) { (image, method) in
      guard let image = image else {
        return
      }
      
      if case .cached = method {
        postView.authorImageView.image = image
        return
      }
      
      DispatchQueue.main.async {
        postView.authorImageView.image = image
      }
    }
    postView.bodyLabel.numberOfLines = 0
    postView.bodyLabel.sizeToFit()
    postView.autoresizingMask = []
    return postView
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section == 1 else {
      return nil
    }
    guard let commentCount = post?.comments.count ?? comments?.count else {
      return nil
    }
    return "\(commentCount) Comments"
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
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return post != nil && indexPath.section == 0 ? nil : indexPath
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    guard let indexPath = self.tableView.indexPathForSelectedRow, let comment = self.comments?[indexPath.row] else {
      return
    }
    if let viewController = segue.destination as? CommentsTableViewController {
      viewController.origin = .comment(comment.comment.id)
    } else if let viewController = segue.destination as? PostsTableViewController {
      viewController.origin = .author(comment.author.id)
    }
  }
  
}
