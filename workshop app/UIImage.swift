//
//  UIImage.swift
//  workshop app
//
//  Created by Leo Dion on 5/23/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

extension UIImage {
  convenience init?(url: URL) {
    
    guard let imageData = try? Data(contentsOf: url) else {
      return nil
    }
    
     self.init(data: imageData)
  }
}
