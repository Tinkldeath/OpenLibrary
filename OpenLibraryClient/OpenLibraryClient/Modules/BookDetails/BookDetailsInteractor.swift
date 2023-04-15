import Foundation
import UIKit

protocol BookDetailsInteractorProtocol {
    
    var presenter: BookDetailsPresenterProtocol? { get set }
    
    func fetch()
    func viewOnSite()
}


final class BookDetailsInteractor: BookDetailsInteractorProtocol {
    
    private var key: String
    private var book: Book
    var presenter: BookDetailsPresenterProtocol?
    
    
    init(_ key: String, _ book: Book) {
        self.key = key
        self.book = book
    }
    
    func fetch() {
        let fetchUrl = URL(string: "https://openlibrary.org\(self.key).json")!
        let fetchSession = URLSession.shared.dataTask(with: URLRequest(url: fetchUrl)) { data, _, _ in
            guard let data = data else { return }
            let description = try? JSONDecoder().decode(SimpleDesctiption.self, from: data)
            let dictDescription = try? JSONDecoder().decode(DictionatyDescription.self, from: data)
            if let text = description?.description {
                self.book.setDescription(text)
            }
            else if let dictDesc = dictDescription?.description["value"] {
                self.book.setDescription(dictDesc)
            }
            DispatchQueue.main.async {
                self.presenter?.presentBook(self.book)
            }
        }
        fetchSession.resume()
    }
    
    func viewOnSite() {
        guard let url = URL(string: "https://openlibrary.org\(self.key)") else {
          return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    struct SimpleDesctiption: Codable {
        var description: String?
        var covers: [Int]?
    }
    
    struct DictionatyDescription: Codable {
        var description: [String: String]
    }
    
}
