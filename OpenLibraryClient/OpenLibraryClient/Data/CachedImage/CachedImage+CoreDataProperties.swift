import Foundation
import CoreData


extension CachedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedImage> {
        return NSFetchRequest<CachedImage>(entityName: "CachedImage")
    }

    @NSManaged public var cover: Int64
    @NSManaged public var image: Data?

}

extension CachedImage : Identifiable {

}
