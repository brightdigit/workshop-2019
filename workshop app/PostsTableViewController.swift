//
//  PostsTableViewController.swift
//  workshop app
//
//  Created by Leo Dion on 5/23/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

enum CacheImageType : Int {
  case post = 1, avatar
}

class CacheImageKey : NSObject {
  let uuid : UUID
  let type : CacheImageType
  
  init (type : CacheImageType, uuid: UUID) {
    self.uuid = uuid
    self.type = type
  }
  
  override var hash: Int {
    return uuid.hashValue ^ type.hashValue
  }
  
  override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? CacheImageKey else {
      return false
    }
    
    return self.uuid == other.uuid && self.type == other.type
  }
}

class PostsTableViewController: UITableViewController {
  static let identifer = "post"
  var posts : [EmbedPost]?
  let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }()
  
  let cache = NSCache<CacheImageKey, UIImage>()
  
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
    
    
    
    if let image = cache.object(forKey: CacheImageKey(type: .post, uuid: post.post.id)) {
      cell.postImageView.image = image
    } else {
      cell.postImageView.image = nil
      URLSession.shared.dataTask(with: post.post.image) { (data, _, _) in
        
        guard let data = data else {
          return
        }
        
        guard let image = UIImage(data: data) else {
          return
        }
        self.cache.setObject(image, forKey: CacheImageKey(type: .post, uuid: post.post.id))
        
        DispatchQueue.main.async {
          guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else {
            return
          }
          
          cell.postImageView.image = image
        }
        }.resume()
    }
    
    if let image = cache.object(forKey: CacheImageKey(type: .avatar, uuid: post.author.id)) {
      cell.authorImageView.image = image
    } else {
      cell.authorImageView.image = nil
      URLSession.shared.dataTask(with: post.author.avatar)  { (data, _, _) in
        
        guard let data = data else {
          return
        }
        
        guard let image = UIImage(data: data) else {
          return
        }
        
        self.cache.setObject(image, forKey: CacheImageKey(type: .avatar, uuid: post.author.id))
        
        DispatchQueue.main.async {
          guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else {
            return
          }
          cell.authorImageView.image = image
        }
        }.resume()
    }
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
