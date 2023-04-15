import Foundation


protocol BookDetailsRouterProtocol {
    
    var view: BookDetailsViewProtocol? { get set }
    
    func routeToList()
}

final class BookDetailsRouter: BookDetailsRouterProtocol {
    
    var view: BookDetailsViewProtocol?
    
    func routeToList() {
        self.view?.navigationController?.popViewController(animated: true)
    }
    
}
