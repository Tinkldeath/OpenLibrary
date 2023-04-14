import Foundation


protocol BookListRouterProtocol {
    
    var view: BookListViewProtocol? { get set }
    var detailsView: BookDetailsViewProtocol? { get }
    
    func routeToBookDetails(_ book: BookListDetailedItemProtocol)

}
