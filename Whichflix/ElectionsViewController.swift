import UIKit
import Alamofire
import Amplitude

class ElectionsViewController: UITableViewController {

    // MARK: Properties

    private let url = "https://warm-wave-23838.herokuapp.com/v1/elections/"

    private var elections = [Election]() {
        didSet {
            tableView.reloadData()
        }
    }


    // MARK: View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Nights"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(userTappedCreateMovieNight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }


    // MARK: UITableViewControllerDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = elections[indexPath.row].title
        return cell
    }


    // MARK: UITableViewControllerDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ElectionViewController(election: elections[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: Public Functions
    public func userTappedLinkToJoinElectionWithID(_ electionID: String) {
        // Dismiss any view controllers and pop to root
        dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)

        // If election exists present it
        let lowercasedElectionIDs = elections.map { $0.id.lowercased() }
        guard !((lowercasedElectionIDs).contains(electionID.lowercased())) else {
            presentElectionWithID(electionID)
            return
        }

        // Join if user has a name, o/w ask for name first
        if UserNameStore.shared.nameExists() {
            joinElectionWithID(electionID)
        } else {
            promptForUserName() { [unowned self, electionID] in
                self.joinElectionWithID(electionID)
            }
        }
    }

    private func joinElectionWithID(_ electionID: String) {
        Client.shared.joinElectionWithID(electionID) { [weak self] in
            guard let election = $0 else { return }
            self?.elections.append(election)
            self?.presentElectionWithID(electionID)
        }
    }

    // MARK: Private Functions

    private func presentElectionWithID(_ electionID: String) {
        guard let election = (elections.filter { $0.id == electionID }.first) else { return }
        let electionViewController = ElectionViewController(election:  election)
        navigationController?.pushViewController(electionViewController, animated: true)
    }

    private func refresh() {
        let title = UserNameStore.shared.nameExists() ? UserNameStore.shared.name : "Enter Name"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(userTappedChangeUserName))
      Client.shared.fetchElections() { [weak self] in
            guard let elections = $0 else { return }
            self?.elections = elections
        }
    }

    @objc private func createElectionWithMovieNightName(_ name: String) {

        Client.shared.createElectionWithName(name) { [weak self] in
            guard let election = $0 else { return }
            self?.elections.append(election)
        }
    }

    @objc private func userTappedCreateMovieNight() {
        Amplitude.instance()?.logEvent("User Tapped Create Movie")
        if UserNameStore.shared.nameExists() {
            promptForMovieNightName()
        } else {
            promptForUserName() { [weak self] in
                self?.promptForMovieNightName()
            }
        }
    }


    @objc private func promptForMovieNightName() {
        let alertController = UIAlertController(title: "Name this movie night", message: nil, preferredStyle: .alert)
        alertController.addTextField()


        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, self] _ in
            let name = alertController.textFields![0].text ?? ""
            self.createElectionWithMovieNightName(name)
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    @objc private func userTappedChangeUserName() {
        Amplitude.instance()?.logEvent("User Tapped Change User Name")
        promptForUserName() {}
    }

    private func promptForUserName(completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let textField = alertController.textFields![0]
        textField.text = UserNameStore.shared.name
        textField.placeholder = "Enter a name"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, completionHandler, self] _ in
            UserNameStore.shared.name = alertController.textFields![0].text ?? ""
            self.refresh()
            completionHandler()
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
