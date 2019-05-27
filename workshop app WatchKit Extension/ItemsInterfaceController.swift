//
//  ItemsInterfaceController.swift
//  workshop app WatchKit Extension
//
//  Created by Leo Dion on 5/26/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

protocol ItemType {
  var message : [String : Any] { get }
  func dataItem(fromDictionary dictionary :  [String: Any]) throws -> DataItem
  func child (withId id: UUID) -> ItemType?
  
  var dataType : DataType { get }
  var id : UUID? { get }
}

enum ItemTypeEnum : ItemType {
  var id: UUID? {
    switch self {
    
    case .posts(let userId):
      return userId
    case .comments(let postId):
      return postId
    default:
      return nil
    }
    
  }
  
  
  var dataType : DataType {
    switch self {
    case .users: return .user
    case .posts(_): return .post
    case .comments(_): return .comment
    }
  }
  
  var message: [String : Any] {
    let command : String
    let id : UUID?
    switch self {
    case .users:
      command = "user"
      id = nil
    case .posts(let userId):
      command = "user"
      id = userId
    case .comments(let postId):
      command = "user"
      id = postId
    }
    var message : [String : Any] = ["command" : command]
    if let id = id {
      message["parentId"] = id
    }
    return message
  }
  
  func dataItem(fromDictionary dictionary: [String : Any]) throws -> DataItem {
    switch self {
    case .users:
      return try UserEmbeded(jsonDictionary: dictionary)
    
    case .posts(_):
      return try PostEmbedded(jsonDictionary: dictionary)
      
    case .comments(_):
      return try CommentEmbedded(jsonDictionary: dictionary)
    }
  }
  
  func child(withId id: UUID) -> ItemType? {
    switch self {
    case .users:
      return ItemTypeEnum.posts(id)
    case .posts(_):
      return ItemTypeEnum.comments(id)
    default:
      return nil
    }
  }
  
  case users
  case posts(UUID?)
  case comments(UUID?)
}

extension Decodable {
  
  /// Initialies the Decodable object with a JSON dictionary.
  ///
  /// - Parameter jsonDictionary: json dictionary.
  /// - Throws: throws an error if the initialization fails.
  init(jsonDictionary: [String: Any]) throws {
    let decoder = JSONDecoder()
    let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
    self = try decoder.decode(Self.self, from: data)
  }
  
}

extension Database {
  func fetch (_ type: ItemType, _ completion : @escaping ([DataItem]?) -> Void) {
    switch type.dataType {
    case .user:
      Database.shared.users(completion)
    case .post:
      if let id = type.id {
      Database.shared.posts(filteredBy: .author(id), completion)
      } else {
      Database.shared.posts(completion)
      }
    case .comment:
      
      if let id = type.id {
        Database.shared.comments(filteredBy: .post(id), completion)
      } else {
        Database.shared.comments(completion)
      }
    }
  }
}


class ItemsInterfaceController: WKInterfaceController {
  var type : ItemType!
  var data : [DataItem]?
  @IBOutlet weak var table : WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    
    
    self.type = context as? ItemType
    
    Database.shared.fetch(type) { (data) in
      self.data = data
      self.reload()
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func reload () {
    guard let data = self.data else {
      return
    }
    
    self.table.setNumberOfRows(data.count, withRowType: "item")
    
    for (index, item) in data.enumerated() {
      guard let row = self.table.rowController(at: index) as? MenuTableRow else {
        continue
      }
      _ = item.image { (image) in
        row.image.setImage(image)
      }
      row.label.setText(item.label)
    }
  }
  
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    guard let item = self.data?[rowIndex] else {
      return
    }
    
    guard let child = self.type.child(withId: item.id) else {
      return
    }
    
    
    self.pushController(withName: "items", context: child )
  }
}
