import Foundation


protocol BookListInteractorProtocol {
    
    var presenter: BookListPresenterProtocol? { get set }
    
    func requestBooks(_ request: String)
    func bookDetails(_ index: Int)
}


final class BookListInteractor: BookListInteractorProtocol  {

    private var books: [BookListDetailedItemProtocol] = []
    var presenter: BookListPresenterProtocol?
    
    func requestBooks(_ request: String) {
        self.presenter?.presentLoading()
        let query = request.lowercased().split(separator: " ").joined(separator: "+")
        let searchUrl = URL(string: "https://openlibrary.org/search.json?title=\(query)")!
        let session = URLSession.shared.dataTask(with: URLRequest(url: searchUrl)) { [weak self] data, _, error in
            if let data = data {
                let docs = try? JSONDecoder().decode(Docs.self, from: data)
                self?.parseDocs(docs ?? Docs(docs: []))
            }
        }
        session.resume()
    }
    
    func bookDetails(_ index: Int) {
        
    }
    
    private func parseDocs(_ docs: Docs) {
        var books = [Book]()
        for doc in docs.docs {
            let rating = (doc.ratings_average != nil) ? "\(doc.ratings_average!)" : "Not rated"
            let firstPublish = (doc.first_publish_year != nil) ? "First publish: \(doc.first_publish_year!)" : "First publish: unknown"
            let book = Book(key: doc.key,
                            description: "",
                            title: doc.title,
                            authors: doc.author_name ?? [],
                            rating: rating,
                            firstPublishDate: firstPublish,
                            cover: doc.cover_i)
            books.append(book)
        }
        self.books = books
        DispatchQueue.main.async {
            self.presenter?.presentBooks(books)
            self.presenter?.presentEndLoading()
        }
    }
    
}

extension BookListInteractor {
    
    struct Doc: Codable {
        var key: String
        var title: String
        var ratings_average: Double?
        var author_name: [String]?
        var cover_i: Int?
        var first_publish_year: Int?
    }
    
    struct Docs: Codable {
        var docs: [Doc]
    }
    
}
