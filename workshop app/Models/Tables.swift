//
//  Tables.swift
//  workshop app
//
//  Created by Leo Dion on 5/26/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation

struct Tables : Codable {
  let posts : [Post]
  let users : [User]
  let comments : [Comment]
}
