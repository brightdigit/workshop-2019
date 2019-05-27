//
//  ItemType.swift
//  workshop app WatchKit Extension
//
//  Created by Leo Dion on 5/27/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit
protocol DataItem {
  var label : String { get }
  func image (_ completion : @escaping (UIImage?) -> Void) -> URLSessionDataTask?
}

extension UserEmbeded : DataItem {
  var label: String { return user.name }
  func image(_ completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
    return Cache.shared.loadImage(fromURL: self.user.avatar, ofType: .avatar, withUUID: self.user.id) { (image, _) in
      completion(image)
    }
  }
}

extension PostEmbedded : DataItem {
  var label: String { return post.title }
  func image(_ completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
    return Cache.shared.loadImage(fromURL: self.post.image, ofType: .post, withUUID: self.post.id) { (image, _) in
      completion(image)
    }
  }
}

extension CommentEmbedded : DataItem {
  
  var label: String { return author.name }
  func image(_ completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
    return Cache.shared.loadImage(fromURL: self.author.avatar, ofType: .avatar, withUUID: self.author.id) { (image, _) in
      completion(image)
    }
  }
}
