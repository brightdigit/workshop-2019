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
}

protocol DataItem {
  
}

protocol DataItemable {
  static func items (_ data : [String : Any]) -> [Self]
}

protocol DataItemFactory {
  associatedtype ItemType : DataItem
  func items (_ data : [String : Any]) -> [ItemType]
}



class ItemsInterfaceController: WKInterfaceController {
  var type : ItemType!
  var data : [DataItem]?
  @IBOutlet weak var image : WKInterfaceImage!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    self.type = context as? ItemType
    image.setImageNamed("ai")
    image.startAnimatingWithImages(in: NSRange(location: 0, length: 40), duration: 1.0, repeatCount: 0)
    
    WCSession.default.sendMessage(type.message, replyHandler: { (reply) in
      
    }) { (error) in
      
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
  
}
