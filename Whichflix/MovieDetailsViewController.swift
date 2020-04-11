import UIKit

class MovieDetailsViewController: UITableViewController {

    private enum CellKind: Int, CaseIterable {
        case Title
        case Year
        case Genre
        case Description

        var name: String {
            switch self {
            case .Title: return "Title"
            case .Year: return "Release Year"
            case .Genre: return "Genre"
            case .Description: return "Description"
            }
        }

        func descriptionForMovie(movie: Movie) -> String {
            switch self {
            case .Title: return movie.title
            case .Year: return movie.releaseYear
            case .Genre: return movie.genres.joined(separator: " ")
            case .Description: return movie.description
            }
        }
    }

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


extension MovieDetailsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellKind = CellKind(rawValue: indexPath.row)!

        let cell = UITableViewCell()
        cell.textLabel?.text = "\(cellKind.name): \(cellKind.descriptionForMovie(movie: movie))"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellKind.allCases.count
    }
}
