//
//  Cache.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit


struct Cache {
  static let shared = Cache()
  let storage = NSCache<Key, UIImage>()
  
  
  
  
  
  func loadImage(fromURL url : URL, ofType type: ImageType, withUUID uuid: UUID, cachePolicy: URLRequest.CachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval = TimeInterval.greatestFiniteMagnitude, _ completion: @escaping (UIImage?, Method) -> Void) -> URLSessionDataTask? {
    let key = Key(type: type, uuid: uuid)
    if let image = storage.object(forKey: key) {
      completion(image, .cached)
    } else {
      #if os(watchOS)
      DispatchQueue.global().async {
        guard let data = try? Data(contentsOf: url) else {
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
      #else
      let urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
      
      let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, _) in
        
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
      #endif
    }
    return nil
  }
}
