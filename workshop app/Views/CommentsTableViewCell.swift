//
//  CommentsTableViewCell.swift
//  workshop app
//
//  Created by Leo Dion on 5/24/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var postTitleLabel: UILabel!
  @IBOutlet weak var authorImageView: UIImageView!
  @IBOutlet weak var authorNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
