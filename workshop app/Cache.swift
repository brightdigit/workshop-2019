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
  static let shared = Cache()
  let storage = NSCache<CacheImageKey, UIImage>()
  
  func loadImage(fromURL url : URL, ofType type: CacheImageType, withUUID uuid: UUID, _ completion: @escaping (UIImage?, CacheMethod) -> Void) -> URLSessionDataTask? {
    let key = CacheImageKey(type: type, uuid: uuid)
    if let image = storage.object(forKey: key) {
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
        self.storage.setObject(image, forKey: key)
        
        DispatchQueue.main.async {
          completion(image, .loaded)
        }
      }
      task.resume()
      return task
    }
    return nil
  }
}
