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
  
}

class ItemsInterfaceController: WKInterfaceController {
  var type : ItemType!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    // Configure interface objects here.
    self.type = context as? ItemType
    
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
