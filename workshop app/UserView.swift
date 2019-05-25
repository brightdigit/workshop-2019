//
//  UserView.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class UserView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var badgeLabel : UILabel!
  @IBOutlet weak var summaryLabel : UILabel!
}
