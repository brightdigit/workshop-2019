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


class ItemsInterfaceController: WKInterfaceController {
  var type : ItemType!
  var data : [DataItem]?
  @IBOutlet weak var table : WKInterfaceTable!
  @IBOutlet weak var image : WKInterfaceImage!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    let dataType = context as? MenuItem.DataType
    
    self.type = dataType
    image.setImageNamed("ai")
    image.startAnimatingWithImages(in: NSRange(location: 0, length: 40), duration: 1.0, repeatCount: 0)
    
    switch dataType {
    case .some(.user):
      Database.shared.users { (users) in
        self.data = users
        self.reload()
      }
    default: break
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
      self.image.setHidden(true)
    }
  }
}
