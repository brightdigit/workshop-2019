//
//  UIView.swift
//  workshop app
//
//  Created by Leo Dion on 5/25/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

extension UIView {
  class func fromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
  }
}
