import Foundation

struct BookListConfigurator {
    
    func configure(_ view: BookListViewProtocol?) {
        let interactor = BookListInteractor()
        let presenter = BookListPresenter(interactor)
        interactor.presenter = presenter
        presenter.view = view
        view?.presenter = presenter
    }
    
}
