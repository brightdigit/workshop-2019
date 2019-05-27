

struct PostEmbedded : Codable {
  let post : Post
  let author : User!
  let comments : [Comment]
}
