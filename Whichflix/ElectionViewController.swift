import UIKit
import Alamofire

class ElectionViewController: UITableViewController, ElectionChangeDelegate {

    weak var delegate: ElectionChangeDelegate?

    private var election: Election {
        didSet {
            title = election.title
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
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(userTappedShare))
        let moreButton = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(userTappedShowMore))
        navigationItem.rightBarButtonItems = [shareButton, moreButton]
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshElection), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshElection()
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


    // MARK: ElectionChangeDelegate

    func electionChangeDidUpdateElection(election: Election) {
        self.election = election
        delegate?.electionChangeDidUpdateElection(election: election)
    }

    func electionChangeDidLeaveElection(election: Election) {
        delegate?.electionChangeDidLeaveElection(election: election)
    }
}
