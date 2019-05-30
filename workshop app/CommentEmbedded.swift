//
//  CommentEmbedded.swift
//  workshop app
//
//  Created by Leo Dion on 5/26/19.
//  Copyright © 2019 Leo Dion. All rights reserved.
//

import Foundation
struct CommentEmbedded : Codable {
  let comment : Comment
  let post : Post!
  let author : User!
}
