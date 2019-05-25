//
//  CommentsTableViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
  static let identifer = "comment"
  var comments : [EmbedComment]?
  weak var alertController : UIAlertController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    Database.shared.comments { (comments) in
      self.comments = comments
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return comments?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let alertController = UIAlertController(title: nil, message: "What would you like to see?", preferredStyle: .actionSheet)
    for action in Action.allCases {
    alertController.addAction(UIAlertAction(title: action.rawValue, style: .default, handler: self.onComment(alertAction:)))
    }
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
  }
  
  enum Action : String, CaseIterable {
    case post = "Post", user = "Comment Author"
  }
  
  func onComment(alertAction: UIAlertAction) {
    guard let title = alertAction.title else {
      return
    }
    guard let action = Action(rawValue: title) else {
      return
    }
    self.performSegue(withIdentifier: action.rawValue, sender: self.alertController)
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
