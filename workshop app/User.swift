//
//  User.swift
//  workshop app
//
//  Created by Leo Dion on 5/20/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct User : Codable {
  let id : UUID
  let name : String
  let avatar : URL
}
