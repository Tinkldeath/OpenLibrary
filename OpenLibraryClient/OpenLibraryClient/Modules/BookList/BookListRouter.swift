import Foundation


protocol BookListRouterProtocol {
    
    var view: BookListViewProtocol? { get set }
    
    func routeToBookDetails(_ key: String, _ book: BookListDetailedItemProtocol)
    
}


final class BookListRouter: BookListRouterProtocol {
    
    var view: BookListViewProtocol?
    private(set) lazy var detailsView: BookDetailsViewProtocol? = {
        if let vc = self.view?.storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController {
            return vc
        }
        return nil
    }()
    
    func routeToBookDetails(_ key: String, _ book: BookListDetailedItemProtocol) {
        if let vc = self.detailsView as? BookDetailsViewController {
            vc.key = key
            vc.book = book
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
