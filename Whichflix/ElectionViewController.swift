import UIKit
import Alamofire

class ElectionViewController: UITableViewController {

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
        let buddiesButton = UIBarButtonItem(title: "Buddies", style: .plain, target: self, action: #selector(userTappedShowPartipants))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(userTappedEdit))
        navigationItem.rightBarButtonItems = [shareButton, buddiesButton, editButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        title = election.title
    }

    @objc private func userTappedShare() {
        let url = URL(string: "whichflix://election?id=\(election.id)")!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

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
        let viewController = PartipantsViewController(participants: election.participants)
        present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
}
