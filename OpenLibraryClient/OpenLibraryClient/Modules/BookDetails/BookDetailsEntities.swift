import Foundation


protocol BookListDetailedItemProtocol: BookListItemProtocol {
    var description: String { get }
    var authors: [String] { get }
    var rating: String { get }
}
