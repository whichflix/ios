import UIKit

class SearchMovieViewController: UIViewController {

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

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Search"
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(userTappedDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Client.shared.searchForMoviesWithQuery(searchQuery: "") { [weak self] movies in
            guard let movies = movies else { return }
            self?.results = movies
        }

        let views: [String: AnyObject] = [
            "tableView": tableViewController.view,
            "topLayoutGuide": view.safeAreaLayoutGuide.topAnchor
        ]

        view.addSubview(tableView)

        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
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
        let cell = UITableViewCell()
        cell.textLabel?.text = movie.title
        return cell
    }
}

extension SearchMovieViewController: UITableViewDelegate {

}
