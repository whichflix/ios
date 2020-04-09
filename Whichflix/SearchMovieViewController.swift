import UIKit
import AlamofireImage

class SearchMovieViewController: UIViewController {

    weak var delegate: MovieAddAttemptDelegate?

    private var results = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var tableView: UITableView {
        return tableViewController.tableView
    }

    private lazy var tableViewController: UITableViewController = {
        let viewController = UITableViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.tableView.dataSource = self
        viewController.tableView.delegate = self
        return viewController
    }()

    private lazy var searchTextFieldView: SearchTextFieldView = {
        let searchTextFieldView = SearchTextFieldView()
        searchTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        searchTextFieldView.placeholder = "Type a movie name or genre"
        return searchTextFieldView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Search"
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(userTappedDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        Client.shared.searchForMoviesWithQuery(searchQuery: "") { [weak self] movies in
            guard let movies = movies else { return }
            self?.results = movies
        }
        view.addSubview(searchTextFieldView)
        view.addSubview(tableView)

        searchTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTextFieldView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true


        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchTextFieldView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func userTappedDismiss() {
        dismiss(animated: true, completion: nil)
    }


}

extension SearchMovieViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = results[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = movie.title
        cell.imageView?.af.setImage(withURL: URL(string: movie.imageURL)!, placeholderImage: UIImage(named: "placeholder-movie.jpg"))
        return cell
    }
}

extension SearchMovieViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let movie = results[indexPath.row]
        let viewController = MovieDetailsViewController(movie: movie)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension SearchMovieViewController: MovieAddAttemptDelegate  {
    func userAttemptedToAddMovie(movie: Movie) {
        delegate?.userAttemptedToAddMovie(movie: movie)
    }
}
