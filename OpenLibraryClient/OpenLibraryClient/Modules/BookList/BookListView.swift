import UIKit


protocol BookListViewProtocol: AnyObject & UIViewController {
    
    var presenter: BookListPresenterProtocol? { get set }
    var router: BookListRouterProtocol { get set }
    
    func displayError()
    func displayNotFound()
    func displayLoading()
    func displayEndLoading()
    func displayBooks(_ books: [BookListItemProtocol])
    
}


class BookCell: UITableViewCell {
    // MARK: - CELL OUTLETS
    @IBOutlet weak var bookImageView: UIImageView?
    @IBOutlet weak var bookTitleLabel: UILabel?
    @IBOutlet weak var bookYearLabel: UILabel?
}


class BookListViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var loadingView: UIActivityIndicatorView?
    @IBOutlet weak var searchButton: UIButton?
    @IBOutlet var booksTableView: UITableView?
    @IBOutlet weak var searchBar: UITextField?
    
    // MARK: - VIPER MODULE
    private var books: [BookListItemProtocol] = []
    private let cellIdentifier = "BookCell"
    private let configurator = BookListConfigurator()
    var router: BookListRouterProtocol = BookListRouter()
    var presenter: BookListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.searchButton?.setTitle("", for: .normal)
        self.loadingView?.isHidden = true
        self.booksTableView?.dataSource = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(clearSearch))
        self.view.addGestureRecognizer(recognizer)
        self.configurator.configure(self)
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        guard let query = self.searchBar?.text else { return }
        guard !query.isEmpty else { self.displayNotFound(); return }
        self.presenter?.interactor.requestBooks(query)
    }
    
    @IBAction func clearClicked(_ sender: Any) {
        self.searchBar?.text = ""
        self.searchBar?.resignFirstResponder()
    }
    
    
    @objc private func clearSearch() {
        DispatchQueue.main.async {
            self.searchBar?.resignFirstResponder()
        }
    }
    
    @IBAction func filterClicked(_ sender: Any) {
        let ac = UIAlertController(title: "Sort", message: "Select option:", preferredStyle: .alert)
        for option in FilterOption.allCases {
            ac.addAction(UIAlertAction(title: option.rawValue, style: .default, handler: { _ in
                self.presenter?.interactor.filter(option)
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(ac, animated: true)
    }
}

extension BookListViewController: BookListViewProtocol {
    
    func displayError() {
        let ac = UIAlertController(title: "Error", message: "Something went wrong, please check your Internet connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func displayNotFound() {
        let ac = UIAlertController(title: "Nothing found", message: "Please try another search request", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func displayLoading() {
        self.searchButton?.isEnabled = false
        self.loadingView?.isHidden = false
        self.loadingView?.startAnimating()
    }
    
    func displayEndLoading() {
        self.searchButton?.isEnabled = true
        self.loadingView?.stopAnimating()
        self.loadingView?.isHidden = true
    }
    
    func displayBooks(_ books: [BookListItemProtocol]) {
        self.books = books
        self.booksTableView?.reloadData()
    }
    
}

extension BookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! BookCell
        let book = self.books[indexPath.row]
        cell.bookTitleLabel?.text = book.title
        cell.bookYearLabel?.text = book.firstPublishDate
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTouchCell))
        cell.addGestureRecognizer(recognizer)
        self.setImage(for: cell, book.cover)
        return cell
    }
    
}

extension BookListViewController{
    
    @objc func didTouchCell(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? BookCell {
            if let index = self.booksTableView?.indexPath(for: cell) {
                self.presenter?.interactor.bookDetails(index.row)
            }
        }
    }
    
}

extension BookListViewController {
    
    private func setImage(for cell: BookCell, _ cover: Int?) {
        guard let cover = cover else {
            cell.bookImageView?.image = UIImage(systemName: "book.fill")!
            return
        }
        if let image = CoreDataManager.shared.findInCache(cover) {
            cell.bookImageView?.image = UIImage(data: image) ?? UIImage(systemName: "book.fill")!
            return
        } else {
            self.fetchImage(for: cell, cover)
        }
    }
    
    private func fetchImage(for cell: BookCell, _ cover: Int) {
        let imageUrl = URL(string: "https://covers.openlibrary.org/b/id/\(cover)-L.jpg")!
        let imageSession = URLSession.shared.dataTask(with: URLRequest(url: imageUrl)) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    cell.bookImageView?.image = UIImage(systemName: "book.fill")
                }
                return
            }
            DispatchQueue.main.async {
                cell.bookImageView?.image = UIImage(data: data)
                CoreDataManager.shared.cache(cover, data)
            }
        }
        imageSession.resume()
    }
    
}
