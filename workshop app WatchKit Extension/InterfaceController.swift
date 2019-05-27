//
//  InterfaceController.swift
//  workshop app WatchKit Extension
//
//  Created by Leo Dion on 5/19/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import WatchKit
import Foundation

struct UnmatchedKeysError<Key> : Error {
  let unmatchedKeys : [Key]
}

func zap<Key,ValueA,ValueB>(_ lhs : Dictionary<Key,ValueA>, _ rhs : Dictionary<Key,ValueB>) throws -> [(Key,ValueA,ValueB)] {
  
  let lhsKeys = Set(lhs.keys)
  let rhsKeys = Set(rhs.keys)
  let unmatchedKeys = lhsKeys.subtracting(rhsKeys).union(rhsKeys.subtracting(lhsKeys))
  guard unmatchedKeys.count == 0 else {
    throw UnmatchedKeysError(unmatchedKeys: [Key](unmatchedKeys))
  }
  
  return lhs.map{
    return ($0.key, $0.value, rhs[$0.key]!)
  }
}

struct MenuItem {
  enum DataType : String, CaseIterable, ItemType {
    var message: [String : Any] {
      return ["command" : self.rawValue]
    }
    
    func dataItem(fromDictionary dictionary: [String : Any]) throws -> DataItem {
      switch self {
      case .user:
        return try UserEmbeded(jsonDictionary: dictionary)
      case .post:
        return try PostEmbedded(jsonDictionary: dictionary)
      case .comment:
        return try CommentEmbedded(jsonDictionary: dictionary)
      }
    }
    
    case user, post, comment
  }
  
  let type : DataType
  let label : String
  let image : UIImage
  
  
  init(_ tuple: (DataType, String, UIImage)) {
    self.type = tuple.0
    self.label = tuple.1
    self.image = tuple.2
  }
  
  static let images : [DataType : UIImage] = [
    .user : UIImage(named: "User-Watch")!,
    .post : UIImage(named: "Post-Watch")!,
    .comment : UIImage(named: "Comment-Watch")!
  ]
  static let labels : [DataType : String] = [
    .user : "Users",
    .post : "Posts",
    .comment : "Comment"
  ]
  
  static let allItems = try! zap(labels,images).map{
    MenuItem($0)
  }
}


class InterfaceController: WKInterfaceController {
  @IBOutlet weak var table : WKInterfaceTable!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    self.table.setNumberOfRows(MenuItem.allItems.count, withRowType: "menuItem")
    
    for (index, menuItem) in MenuItem.allItems.enumerated() {
      guard let row = table.rowController(at: index) as? MenuTableRow else {
        continue
      }
      
      
      row.image.setImage(menuItem.image)
      row.label.setText(menuItem.label)
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
 
  override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    let type = MenuItem.allItems[rowIndex].type
    
    self.pushController(withName: "items", context: type)
  }
}
