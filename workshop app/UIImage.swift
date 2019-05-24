//
//  UIImage.swift
//  workshop app
//
//  Created by Leo Dion on 5/23/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImage(fromURL url : URL) {
    return URLSession.shared.downloadTask(with: url) { (url, _, _) in
      DispatchQueue.main.async {
        guard let path = url?.path else {
          return
        }
        self.image = UIImage(contentsOfFile: path)
          
      }
    }.resume()
  }
}
