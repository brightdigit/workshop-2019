//
//  PostView.swift
//  workshop app
//
//  Created by Leo Dion on 5/25/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class PostView: UITableViewCell {

  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var postTitleLabel: UILabel!
  @IBOutlet weak var publishDateLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var commentSummaryLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
