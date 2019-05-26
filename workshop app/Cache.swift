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
  
  
  enum ImageType : Int {
    case post = 1, avatar
  }
  
  class Key : NSObject {
    let uuid : UUID
    let type : ImageType
    
    init (type : ImageType, uuid: UUID) {
      self.uuid = uuid
      self.type = type
    }
    
    override var hash: Int {
      return uuid.hashValue ^ type.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
      guard let other = object as? Key else {
        return false
      }
      
      return self.uuid == other.uuid && self.type == other.type
    }
  }
  enum Method {
    case cached, loaded
  }
  
  func loadImage(fromURL url : URL, ofType type: ImageType, withUUID uuid: UUID, _ completion: @escaping (UIImage?, Method) -> Void) -> URLSessionDataTask? {
    let key = Key(type: type, uuid: uuid)
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
