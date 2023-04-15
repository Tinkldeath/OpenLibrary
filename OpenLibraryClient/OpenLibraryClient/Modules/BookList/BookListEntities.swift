import Foundation
import UIKit

protocol BookListItemProtocol {
    var title: String { get }
    var firstPublishDate: String  { get }
    var cover: Int? { get }
}


struct Book: BookListDetailedItemProtocol {
    
    var key: String
    var description: String
    var title: String
    var authors: [String]
    var rating: String
    var firstPublishDate: String
    var cover: Int?
    
    mutating func setDescription(_ description: String) {
        self.description = description
    }
    
    mutating func setCover(_ cover: Int?) {
        self.cover = cover
    }
    
}

enum FilterOption: String, CaseIterable {
    case ratingUp = "Top rated first"
    case ratingDown = "Top rated last"
    case coverFirst = "With cover first"
}
