import Foundation
import UIKit

protocol BookDetailsPresenterProtocol {
    
    var view: BookDetailsViewProtocol? { get set }
    var interactor: BookDetailsInteractorProtocol { get }
    
    func presentBook(_ book: BookListDetailedItemProtocol)
}


final class BookDetailsPresenter: BookDetailsPresenterProtocol {
    
    weak var view: BookDetailsViewProtocol?
    var interactor: BookDetailsInteractorProtocol
    
    init(_ interactor: BookDetailsInteractorProtocol) {
        self.interactor = interactor
    }
    
    func presentBook(_ book: BookListDetailedItemProtocol) {
        self.view?.displayTitle(book.title)
        self.view?.displayRating(book.rating)
        self.view?.displayAuthors(book.authors.joined(separator: ", "))
        self.view?.displayDescription(book.description)
        self.view?.displayFirstPublish(book.firstPublishDate)
        if let rating = Double(book.rating) {
            self.view?.displayStarRating(Int(rating))
            self.view?.displayRating("\(round(rating*100)/100)/5.0")
        } else {
            self.view?.displayStarRating(-1)
        }
        guard let cover = book.cover else {
            self.view?.displayCover(UIImage(systemName: "book.fill")!)
            return
        }
        if let cached = CoreDataManager.shared.findInCache(cover) {
            self.view?.displayCover(UIImage(data: cached) ?? UIImage(systemName: "book.fill")!)
        } else {
            let imageUrl = URL(string: "https://covers.openlibrary.org/b/id/\(cover)-L.jpg")!
            let imageSession = URLSession.shared.dataTask(with: URLRequest(url: imageUrl)) { data, _, _ in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.view?.displayCover(UIImage(systemName: "book.fill")!)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.view?.displayCover(UIImage(data: data)!)
                    CoreDataManager.shared.cache(cover, data)
                }
            }
            imageSession.resume()
        }
    }
    
}
