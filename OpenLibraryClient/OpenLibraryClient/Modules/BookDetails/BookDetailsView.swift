import UIKit


protocol BookDetailsViewProtocol: AnyObject & UIViewController {
    
    var router: BookDetailsRouterProtocol { get set }
    var presenter: BookDetailsPresenterProtocol? { get set }
    
    func displayTitle(_ title: String)
    func displayAuthors(_ authors: String)
    func displayRating(_ rating: String)
    func displayStarRating(_ filled: Int)
    func displayFirstPublish(_ firstPublish: String)
    func displayDescription(_ description: String)
    func displayCover(_ cover: UIImage)
    
}

class BookDetailsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var bookTitleLabel: UILabel?
    @IBOutlet weak var bookCoverImageView: UIImageView?
    @IBOutlet var starViews: [UIImageView]!
    @IBOutlet weak var bookRatingLabel: UILabel?
    @IBOutlet weak var bookAuthorsLabel: UILabel?
    @IBOutlet weak var bookFirstPublishLabel: UILabel?
    @IBOutlet weak var bookDespcriptionTextView: UITextView?
    
    
    // MARK: - VIPER MODULE COMPONENTS
    private var configurator = BookDetailsConfigurator()
    var presenter: BookDetailsPresenterProtocol?
    var router: BookDetailsRouterProtocol = BookDetailsRouter()
    var key: String = ""
    var book: BookListDetailedItemProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configurator.configure(self, self.key, self.book)
        self.presenter?.interactor.fetch()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.router.routeToList()
    }
    
    @IBAction func viewOnSiteClicked(_ sender: Any) {
        self.presenter?.interactor.viewOnSite()
    }
    
}

extension BookDetailsViewController: BookDetailsViewProtocol {
    
    func displayTitle(_ title: String) {
        self.bookTitleLabel?.text = title
    }
    
    func displayAuthors(_ authors: String) {
        self.bookAuthorsLabel?.text = authors
    }
    
    func displayRating(_ rating: String) {
        self.bookRatingLabel?.text = rating
    }
    
    func displayStarRating(_ filled: Int) {
        for star in self.starViews {
            if star.tag <= filled {
                star.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor.yellow, renderingMode: .alwaysTemplate)
            }else {
                star.image = UIImage(systemName: "star")?.withTintColor(UIColor.yellow, renderingMode: .alwaysTemplate)
            }
        }
    }
    
    func displayFirstPublish(_ firstPublish: String) {
        self.bookFirstPublishLabel?.text = firstPublish
    }
    
    func displayDescription(_ description: String) {
        self.bookDespcriptionTextView?.text = description
    }
    
    func displayCover(_ cover: UIImage) {
        self.bookCoverImageView?.image = cover
    }
    
    
}
