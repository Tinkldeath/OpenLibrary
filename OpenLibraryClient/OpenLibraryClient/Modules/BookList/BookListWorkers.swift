import Foundation


protocol WorkerPortocol {
    func work()
}

class DocsWorker: WorkerPortocol {
    
    struct Doc: Codable {
        var key: String
        var authors: [String]?
        var title: String?
        var cover_i: Int?
        var first_publish_year: Int?
        var ratings_average: Double?
    }
    
    struct Docs: Codable {
        var docs: [Doc]
    }
    
    private(set) var query: String
    private(set) var docs: Observable<[Doc]> = Observable(value: [])
    private(set) var error: Observable<Error?> = Observable(value: nil)
    
    init(request: String) {
        self.query = request.lowercased().split(separator: " ").joined(separator: "+")
    }
    
    func work() {
        let searchUrl = URL(string: "https://openlibrary.org/search.json?title=\(self.query)")!
        let session = URLSession.shared.dataTask(with: URLRequest(url: searchUrl)) { data, _, error in
            guard let data = data else { return }
            guard error == nil else { self.error.value = error; return }
            do {
                let docs = try JSONDecoder().decode(Docs.self, from: data)
                self.docs.value = docs.docs
            } catch {
                self.error.value = error
            }
        }
        session.resume()
    }
    
}
