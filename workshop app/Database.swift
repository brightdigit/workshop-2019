//
//  Database.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct Tables : Codable {
  let posts : [Post]
  let users : [User]
  let comments : [Comment]
}

struct EmbedUser {
  let user : User
  let posts : [Post]
  
  var latestPost : Post? {
    return posts.max(by: { $0.date < $1.date})
  }
}

struct EmbedPost {
  let post : Post
  let author : User!
  let comments : [Comment]
}

struct EmbedComment {
  let comment : Comment
  let post : Post!
  let author : User!
}

class Database {
  static let shared = Database()
  
  let tables : Tables
  
  private init () {
    let bundle = Bundle(for: Database.self)
    let databaseURL = bundle.url(forResource: "db", withExtension: "json")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted({
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
      return formatter
    }())
    let data = try! Data(contentsOf: databaseURL!)
    let tables = try! decoder.decode(Tables.self, from: data)
    self.tables = tables
  }
  
  func users (_ completion: @escaping ([EmbedUser]) -> Void) {
    DispatchQueue.global().async {
      let postDictionary = Dictionary.init(grouping: self.tables.posts, by: {
        return $0.userId
      })
      let userPosts = self.tables.users.map{
        EmbedUser(user: $0, posts: postDictionary[$0.id] ?? [Post]())
      }
      completion(userPosts)
    }
  }
  
  func posts (_ completion: @escaping ([EmbedPost]) -> Void) {
    DispatchQueue.global().async {
      let postComments = Dictionary.init(grouping: self.tables.comments, by: {
        return $0.postId
      })
      let userDictionary = [UUID : [User]](grouping: self.tables.users, by: { $0.id })
      let posts = self.tables.posts.map{
        return EmbedPost(post: $0, author: userDictionary[$0.userId]?.first, comments: postComments[$0.id] ?? [Comment]())
      }.sorted(by: { $0.post.date > $1.post.date })
      completion(posts)
    }
  }
  
  
  func comments (_ completion: @escaping ([EmbedComment]) -> Void) {
    DispatchQueue.global().async {
      let postDictionary = Dictionary.init(grouping: self.tables.posts, by: {
        return $0.id
      })
      let userDictionary = [UUID : [User]](grouping: self.tables.users, by: { $0.id })
      let comments = self.tables.comments.map{
        return EmbedComment(comment: $0, post: postDictionary[$0.postId]?.first, author: userDictionary[$0.userId]?.first)
        }.sorted(by: {$0.comment.date > $1.comment.date})
      completion(comments)
    }
  }
}
