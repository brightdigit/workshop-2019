import Foundation

extension Cache {
  class Key : NSObject {
    let uuid : UUID
    let type : ImageType
    
    init (type : ImageType, uuid: UUID) {
      self.uuid = uuid
      self.type = type
    }
    
    override var hash: Int {
      return uuid.hashValue ^ type.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
      guard let other = object as? Key else {
        return false
      }
      
      return self.uuid == other.uuid && self.type == other.type
    }
  }
}
