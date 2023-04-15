import Foundation


struct BookDetailsConfigurator {
    
    func configure(_ view: BookDetailsViewProtocol?, _ key: String, _ book: BookListDetailedItemProtocol?) {
        guard let book = book as? Book else { return }
        let interactor = BookDetailsInteractor(key, book)
        let presenter = BookDetailsPresenter(interactor)
        interactor.presenter = presenter
        view?.presenter = presenter
        presenter.view = view
        view?.router.view = view
    }
    
}
