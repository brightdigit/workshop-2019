//
//  Comment.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct Comment : Codable {
  let id : UUID
  let postId : UUID
  let userId : UUID
  let text : String
}
