import UIKit
import Alamofire
import Amplitude

class ElectionsViewController: UITableViewController {

    // MARK: Properties

    private let url = "https://warm-wave-23838.herokuapp.com/v1/elections/"

    private let session: Alamofire.Session

    private var userNameStore = UserNameStore()

    private var elections = [Election]() {
        didSet {
            tableView.reloadData()
        }
    }


    // MARK: Initialization

    init(session: Alamofire.Session) {
        self.session = session
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let viewController = ElectionViewController(session: session, election: elections[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }


    // MARK: Public Functions
    public func userTappedLinkToJoinElectionWithID(_ electionID: String) {
        // Dismiss any view controllers and pop to root
        dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)


        if userNameStore.nameExists() {
            joinElectionWithID(electionID)
        } else {
            promptForUserName() { [unowned self, electionID] in
                self.joinElectionWithID(electionID)
            }
        }


        let lowercasedElectionIDs = elections.map { $0.id.lowercased() }
        guard !((lowercasedElectionIDs).contains(electionID.lowercased())) else {
            presentElectionWithID(electionID)
            return
        }
    }

    public func joinElectionWithID(_ electionID: String) {
        navigationController?.popToRootViewController(animated: true)
        let lowercasedElectionIDs = elections.map { $0.id.lowercased() }
        guard !((lowercasedElectionIDs).contains(electionID.lowercased())) else {
            presentElectionWithID(electionID)
            return
        }
        let fullURL = "\(url)\(electionID)/participants/"
        let parameters = [
            "name": userNameStore.name
        ]
        session.request(fullURL, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { [weak self] response in
                print(response)
                guard let election = response.value,
                    let strongSelf = self else { return }
                strongSelf.elections.append(election)
                let electionViewController = ElectionViewController(session: strongSelf.session, election: election)
                strongSelf.navigationController?.pushViewController(electionViewController, animated: true)
        }
    }

    // MARK: Private Functions

    private func presentElectionWithID(_ electionID: String) {
        guard let election = (elections.filter { $0.id == electionID }.first) else { return }
        let electionViewController = ElectionViewController(session:session, election:  election)
        navigationController?.pushViewController(electionViewController, animated: true)
    }

    private func refresh() {
        let title = userNameStore.nameExists() ? userNameStore.name : "Enter Name"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(userTappedChangeUserName))
        session.request(url, method: .get)
            .validate()
            .responseDecodable(of: Elections.self) { response in
                print(response)
                guard let elections = response.value else { return }
                self.elections = elections.all
        }
    }

    @objc private func createElectionWithMovieNightName(_ name: String) {
        let parameters = [
            "title": "\(name)",
            "initiator_name": "\(userNameStore.name)"
        ]
        session.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Election.self) { [weak self] response in
                print(response)
                guard let election = response.value else { return }
                print(election.title)
                self?.refresh()
        }
    }

    @objc private func userTappedCreateMovieNight() {
        Amplitude.instance()?.logEvent("User Tapped Create Movie")
        if userNameStore.nameExists() {
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
        textField.text = userNameStore.name
        textField.placeholder = "Enter a name"

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController, completionHandler, self] _ in
            self.userNameStore.name = alertController.textFields![0].text ?? ""
            self.refresh()
            completionHandler()
        }

        alertController.addAction(submitAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}
