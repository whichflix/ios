import UIKit
import AlamofireImage

protocol MovieAddAttemptDelegate: class {
    func userAttemptedToAddMovie(movie: Movie)
}

protocol CandidateVoteToggleAttemptDelegate: class {
    func userAttemptedToToggleVote(candidate: Candidate)
}

class ElectionViewController: UITableViewController {

    weak var delegate: ElectionChangeDelegate?

    private var election: Election {
        didSet {
            title = election.title
            tableView.reloadData()
            delegate?.electionChangeDidUpdateElection(election: election)
        }
    }

    init(election: Election) {
        self.election = election
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(userTappedShare))
        let moreButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(userTappedShowMore))
        let searchButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(userTappedSearch))
        navigationItem.rightBarButtonItems = [searchButton, shareButton, moreButton]
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshElection), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshElection()
    }

    private func userAttemptedAddMovie(movie: Movie) {
        Client.shared.createCandidateInElection(election: election, forMovie: movie) { [weak self] in
            guard let election = $0 else { return }
            self?.election = election
        }
    }

    @objc private func refreshElection() {
        Client.shared.fetchElectionWithID(election.id) { [weak self] in
            guard let election = $0 else { return }
            self?.election = election
        }
    }

    @objc private func userTappedShare() {
        let url = URL(string: "whichflix://election?id=\(election.id)")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    @objc private func userTappedShowMore() {
        let viewController = ElectionMoreViewControler(election: election)
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }

    @objc private func userTappedSearch() {
        let viewController = SearchMovieViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
}


extension ElectionViewController: ElectionChangeDelegate {
    func electionChangeDidUpdateElection(election: Election) {
        self.election = election
    }

    func electionChangeDidLeaveElection(election: Election) {
        delegate?.electionChangeDidLeaveElection(election: election)
    }
}


extension ElectionViewController: MovieAddAttemptDelegate {
    func userAttemptedToAddMovie(movie: Movie) {
        dismiss(animated: true, completion: nil)
        userAttemptedAddMovie(movie: movie)
    }
}

extension ElectionViewController: CandidateVoteToggleAttemptDelegate {

    func userAttemptedToToggleVote(candidate: Candidate) {

        guard let index = election.candidates.map({ $0.id }).firstIndex(of: candidate.id) else { return }

        if !candidate.containsMyVote {
            election.candidates[index].addMe()
            Client.shared.castVoteForCandidate(candidate: candidate) { [weak self] in
                guard let candidate = $0 else { return }
                self?.election.candidates[index] = candidate
            }
        } else {
            election.candidates[index].removeMe()
            Client.shared.removeVoteFromCandidate(candidate: candidate) { _ in }
        }
    }
}


extension ElectionViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return election.candidates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let candidate = election.candidates[indexPath.row]

        let cell = CandidateTableViewCell(candidate: candidate)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let candidate = election.candidates[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = CandidateViewController(candidate: candidate)
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}
