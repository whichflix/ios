import UIKit

class AddMovieViewController: MovieDetailsViewController {

    weak var delegate: MovieAddAttemptDelegate?

    override init(movie: Movie) {
        super.init(movie: movie)
        let addToElectionButton = UIBarButtonItem(title: "Add To Movie Night", style: .plain, target: self, action: #selector(userTappedAddToElection))
        navigationItem.rightBarButtonItem = addToElectionButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func userTappedAddToElection() {
        delegate?.userAttemptedToAddMovie(movie: movie)
    }
}

class CandidateViewController: MovieDetailsViewController {
    init(candidate: Candidate) {
        super.init(movie: candidate.movie)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MovieDetailsViewController: UITableViewController {

    private enum CellKind: Int, CaseIterable {
        case Title
        case Description
        case Year
        case Genre

        func descriptionForMovie(movie: Movie) -> String {
            switch self {
            case .Title: return movie.title
            case .Year: return movie.releaseYear
            case .Genre: return movie.genres.joined(separator: ", ")
            case .Description: return movie.description
            }
        }
    }

    fileprivate let movie: Movie

    private lazy var headerView: MovieDetailsHeaderView = {
        let view = MovieDetailsHeaderView(movie: movie)
        view.frame = CGRect(x: 0, y: 0, width: 0, height:512)
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
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
    }
}


fileprivate extension MovieDetailsViewController {
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellKind = CellKind(rawValue: indexPath.row)!

        let standardCellLabel: String
        let standardCellDescription: String

        switch cellKind {
        case .Title: return MovieTitleTableViewCell(title: movie.title)
        case .Year:
            standardCellLabel = "Release Year: "
            standardCellDescription = movie.releaseYear
        case .Genre:
            standardCellLabel = movie.genres.count > 1 ? "Genres: " : "Genre: "
            standardCellDescription = movie.genres.joined(separator: ", ")
        case .Description: return MovieDescriptionTableViewCell(description: movie.description)
        }

        let cell = UITableViewCell()
        cell.textLabel?.text = "\(standardCellLabel)\(standardCellDescription)"
        return cell
    }

    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellKind.allCases.count
    }
}
