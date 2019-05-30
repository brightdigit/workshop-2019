//
//  UserTableViewCell.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var badgeLabel : UILabel!
  @IBOutlet weak var postsSummaryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
