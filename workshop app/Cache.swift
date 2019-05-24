//
//  Cache.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

enum CacheMethod {
  case cached, loaded
}

struct Cache {
  static let shared = NSCache<CacheImageKey, UIImage>()

  static func loadImage(fromURL url : URL, ofType type: CacheImageType, withUUID uuid: UUID, _ completion: @escaping (UIImage?, CacheMethod) -> Void) -> URLSessionDataTask? {
    let key = CacheImageKey(type: type, uuid: uuid)
    if let image = Cache.shared.object(forKey: key) {
      completion(image, .cached)
      
      //cell.postImageView.image = image
    } else {
      //cell.postImageView.image = nil
      let task = URLSession.shared.dataTask(with:url) { (data, _, _) in
        
        guard let data = data else {
          completion(nil, .loaded)
          return
        }
        
        guard let image = UIImage(data: data) else {
          completion(nil, .loaded)
          return
        }
        Cache.shared.setObject(image, forKey: key)
        
        DispatchQueue.main.async {
          completion(image, .loaded)
//          guard let cell = tableView.cellForRow(at: indexPath) as? PostsTableViewCell else {
//            return
//          }
//
//          cell.postImageView.image = image
        }
        }
      task.resume()
      return task
    }
    return nil
  }
}
