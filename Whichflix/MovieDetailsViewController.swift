import UIKit

class MovieDetailsViewController: UITableViewController {

    weak var delegate: MovieAddAttemptDelegate?

    private let movie: Movie

    private lazy var headerView: MovieDetailsHeaderView = {
        let view = MovieDetailsHeaderView(movie: movie)
        view.frame = CGRect(x: 0, y: 0, width: 0, height:256)
        return view
    }()

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        let addToElectionButton = UIBarButtonItem(title: "Add To Movie Night", style: .plain, target: self, action: #selector(userTappedAddToElection))
        navigationItem.rightBarButtonItem = addToElectionButton
    }

    @objc private func userTappedAddToElection() {
        delegate?.userAttemptedToAddMovie(movie: movie)
    }
}
