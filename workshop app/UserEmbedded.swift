

struct UserEmbeded {
  let user : User
  let posts : [Post]
  
  var latestPost : Post? {
    return posts.max(by: { $0.date < $1.date})
  }
}
