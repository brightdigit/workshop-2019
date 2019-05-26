//
//  Database.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation







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
  
  func users (_ completion: @escaping ([UserEmbeded]) -> Void) {
    DispatchQueue.global().async {
      let postDictionary = Dictionary.init(grouping: self.tables.posts, by: {
        return $0.userId
      })
      let userPosts = self.tables.users.map{
        UserEmbeded(user: $0, posts: postDictionary[$0.id] ?? [Post]())
      }
      completion(userPosts)
    }
  }
  
  func posts (filteredBy filter: PostFilter? = nil ,_ completion: @escaping ([PostEmbedded]) -> Void) {
    DispatchQueue.global().async {
      let postComments = Dictionary.init(grouping: self.tables.comments, by: {
        return $0.postId
      })
      
      let userDictionary = [UUID : [User]](grouping: self.tables.users, by: { $0.id })
      let postDictionary = [UUID : [Post]](grouping: self.tables.posts, by: {
        return $0.id
      })
      let posts = postDictionary.flatMap{ $0.value }.filter({ (post) -> Bool in
        guard let filter = filter else {
          return true
        }
        switch (filter) {
        case .author(let userId): return post.userId == userId
        case .authorWithPost(let postId): return postDictionary[postId]?.map{ $0.userId }.contains(post.userId) ?? false
        }
      }).map{
        return PostEmbedded(post: $0, author: userDictionary[$0.userId]?.first, comments: postComments[$0.id] ?? [Comment]())
      }.sorted(by: { $0.post.date > $1.post.date })
      completion(posts)
    }
  }
  
  func post (selectedBy selection: PostSelection, _ completion: @escaping (PostEmbedded?) -> Void) {
    DispatchQueue.global().async {
      let foundPostId : UUID?
      switch (selection) {
      case .comment(let commentId):
        foundPostId = self.tables.comments.first(where: { $0.id == commentId})?.postId
      case .post(let id):
        foundPostId = id
      }
      
      guard let postId = foundPostId else {
        return completion(nil)
      }
      
      guard let post = self.tables.posts.first(where: {$0.id == postId}) else {
        return completion(nil)
      }
      
      guard let user = self.tables.users.first(where: {$0.id == post.userId}) else {
        return completion(nil)
      }
      
      let comments = self.tables.comments.filter({ $0.postId == post.id }).sorted(by: { $0.date > $1.date })
      
      completion(PostEmbedded(post: post, author: user, comments: comments))
    }
  }
  
  
  func comments (filteredBy filter: CommentFilter? = nil , _ completion: @escaping ([CommentEmbedded]) -> Void) {
    DispatchQueue.global().async {
      let postDictionary = Dictionary.init(grouping: self.tables.posts, by: {
        return $0.id
      })
      let userDictionary = [UUID : [User]](grouping: self.tables.users, by: { $0.id })
      let commentDictionary = [UUID: [Comment]].init(grouping: self.tables.comments, by: {
        $0.id
      })
      
      let comments = commentDictionary.flatMap{ return $0.value }.filter({ (comment) -> Bool in
        guard let filter = filter else {
          return true
        }
        switch (filter) {
        case .post(let postId): return comment.postId == postId
        case .postWithComment(let commentId): return commentDictionary[commentId]?.map{ $0.postId }.contains(comment.postId) ?? false
        }
        
      }).map{
        return CommentEmbedded(comment: $0, post: postDictionary[$0.postId]?.first, author: userDictionary[$0.userId]?.first)
        }.sorted(by: {$0.comment.date > $1.comment.date})
      completion(comments)
    }
  }
}
