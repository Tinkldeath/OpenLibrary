import Foundation


protocol BookListPresenterProtocol {
    var view: BookListViewProtocol? { get set }
    var interactor: BookListInteractorProtocol { get }
    
    func presentLoading()
    func presentError()
    func presentNotFound()
    func presentBooks(_ books: [BookListItemProtocol])
    func presentEndLoading()
    func presentBookDetails(_ book: BookListDetailedItemProtocol)
}


final class BookListPresenter: BookListPresenterProtocol {
    
    weak var view: BookListViewProtocol?
    
    private(set) var interactor: BookListInteractorProtocol
    
    init(_ interactor: BookListInteractorProtocol) {
        self.interactor = interactor
    }
    
    func presentLoading() {
        self.view?.displayLoading()
    }
    
    func presentError() {
        self.view?.displayError()
    }
    
    func presentNotFound() {
        self.view?.displayNotFound()
    }
    
    func presentBooks(_ books: [BookListItemProtocol]) {
        self.view?.displayBooks(books)
    }
    
    func presentEndLoading() {
        self.view?.displayEndLoading()
    }
    
    func presentBookDetails(_ book: BookListDetailedItemProtocol) {
    
    }
    
}
