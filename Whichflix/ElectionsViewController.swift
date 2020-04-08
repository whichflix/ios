import UIKit
import Alamofire
import Amplitude

class ElectionsViewController: UITableViewController, ElectionChangeDelegate {

    // MARK: Properties

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
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(userPulledToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshElections()
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        Client.shared.leaveElectionWithID(elections[indexPath.row].id) { [weak self] _ in
            self?.elections.remove(at: indexPath.row)
        }
    }



    // MARK: UITableViewControllerDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ElectionViewController(election: elections[indexPath.row])
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: Public Functions

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

    private func refreshElections() {
        let title = UserNameStore.shared.nameExists() ? UserNameStore.shared.name : "Enter Name"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(userTappedChangeUserName))
        self.tableView.refreshControl?.beginRefreshing()
      Client.shared.fetchElections() { [weak self] in
            guard let elections = $0 else { return }
            self?.elections = elections
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func createElectionWithMovieNightName(_ name: String) {

        Client.shared.createElectionWithName(name) { [weak self] in
            guard let election = $0 else { return }
            self?.elections.append(election)
        }
    }

    private func promptForMovieNightName() {
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

    private func promptForUserName(completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alertController.addTextField()

        let textField = alertController.textFields![0]
        textField.text = UserNameStore.shared.name
        textField.placeholder = "Enter a name"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, completionHandler, self] _ in
            UserNameStore.shared.name = alertController.textFields![0].text ?? ""
            self.refreshElections()
            completionHandler()
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

    private func popAll() {
        dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)
    }


    // MARK: User Actions

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
        Amplitude.instance()?.logEvent("Elections List View: User Came From Link To Join Election")
    }

    @objc private func userPulledToRefresh() {
        Amplitude.instance()?.logEvent("Elections List View: User Pulled To Refresh")
        refreshElections()
    }

    @objc private func userTappedCreateMovieNight() {
          Amplitude.instance()?.logEvent("Elections List View: User Tapped Create Movie")
          if UserNameStore.shared.nameExists() {
              promptForMovieNightName()
          } else {
              promptForUserName() { [weak self] in
                  self?.promptForMovieNightName()
              }
          }
      }

      @objc private func userTappedChangeUserName() {
          Amplitude.instance()?.logEvent("User Tapped Change User Name")
          promptForUserName() {}
      }


    // MARK: ElectionChangeDelegate

    func electionChangeDidUpdateElection(election updatedElection: Election) {
        guard let index = elections.map({ $0.id }).firstIndex(of: updatedElection.id) else {
            refreshElections()
            return
        }
        elections[index] = updatedElection
    }

    func electionChangeDidLeaveElection(election electionLeft: Election) {
        guard let index = elections.map({ $0.id }).firstIndex(of: electionLeft.id) else {
            refreshElections()
            return
        }
        elections.remove(at: index)
        self.popAll()
    }
}
