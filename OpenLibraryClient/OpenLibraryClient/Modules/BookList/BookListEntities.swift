import Foundation
import UIKit

protocol BookListItemProtocol {
    var title: String { get }
    var firstPublishDate: String  { get }
    var cover: Int? { get }
}

protocol BookListDetailedItemProtocol: BookListItemProtocol {
    var description: String { get }
    var authors: [String] { get }
    var rating: String { get }
}

struct FetchedData: Codable {
    var title: String?
    var description: String?
    var covers: [Int]?
    var first_publish_date: String?
}

struct Book: BookListDetailedItemProtocol {
    
    var key: String
    var description: String
    var title: String
    var authors: [String]
    var rating: String
    var firstPublishDate: String
    var cover: Int?
    
}
