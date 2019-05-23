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
  var posts : [EmbedPost]?
  let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    Database.shared.posts { (posts) in
      self.posts = posts
      DispatchQueue.main.async {
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
    
    guard let cell = dequeuedCell as? PostTableViewCell else {
      return dequeuedCell
    }
    
    guard let post = self.posts?[indexPath.row] else {
      return cell
    }
    
    cell.postImageView.image = UIImage(url: post.post.image)
    cell.authorImageView.image = UIImage(url: post.author.avatar)
    cell.authorNameLabel.text = post.author.name
    cell.postTitleLabel.text = post.post.title
    cell.publishDateLabel.text = dateFormatter.string(from: post.post.date)
    cell.bodyLabel.text = post.post.text
    cell.commentSummaryLabel.text = "\(post.comments.count) comments"
    
    return cell
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
