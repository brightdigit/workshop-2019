//
//  Post.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct Post : Codable {
  let userId : UUID
  let id : UUID
  let title : String
  let image: URL
  let text: String
  let date: Date
}
