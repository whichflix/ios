import UIKit

class ElectionMoreViewControler: UITableViewController, ElectionChangeDelegate  {

    weak var delegate: ElectionChangeDelegate?

    private var election: Election {
        didSet {
            title = election.title
            electionChangeDidUpdateElection(election: election)
        }
    }

    private enum Action: Int, CaseIterable {
        case Participants
        case EditName
        case Leave

        var title: String {
            switch self {
            case .Participants: return "Participants"
            case .EditName: return "Edit Name"
            case .Leave: return "Leave"
            }
        }

        func commitOn(moreVC: ElectionMoreViewControler) {
            switch self {
            case .Participants: moreVC.userTappedShowPartipants()
            case .EditName: moreVC.userTappedEdit()
            case .Leave: moreVC.userTappedLeave()
            }
        }
    }

    init(election: Election) {
        self.election = election
        super.init(style: .grouped)
        title = election.title
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(userTappedDismiss))
        navigationItem.leftBarButtonItem = dismissButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Action.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let actionTitle = Action(rawValue: indexPath.row)!.title
        let cell = UITableViewCell()
        cell.textLabel?.text = actionTitle
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Action(rawValue: indexPath.row)!.commitOn(moreVC: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: User Actions
    
    @objc private func userTappedEdit() {
        let alertController = UIAlertController(title: "Rename movie night", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let textField = alertController.textFields![0]
        textField.text = election.title
        textField.placeholder = "Enter a movie night name"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, self] _ in
            let movieNightName = alertController.textFields![0].text!
            if movieNightName.count > 0 {
                Client.shared.changeElectionName(newName: movieNightName, electionID: self.election.id) { [weak self] in
                    guard let election = $0 else { return }
                    self?.election = election
                }
            }
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    @objc private func userTappedShowPartipants() {
        let viewController = PartipantsViewController(election: election)
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }

    @objc private func userTappedLeave() {
        Client.shared.leaveElectionWithID(election.id) { [weak self] in
            guard let election = $0 else { return }
            self?.electionChangeDidLeaveElection(election: election)
        }
    }

    @objc private func userTappedDismiss() {
        dismiss(animated: true, completion: nil)
    }


    // MARK: ElectionChangeDelegate

    func electionChangeDidUpdateElection(election: Election) {
        delegate?.electionChangeDidUpdateElection(election: election)
    }

    func electionChangeDidLeaveElection(election: Election) {
        delegate?.electionChangeDidLeaveElection(election: election)
    }
}
